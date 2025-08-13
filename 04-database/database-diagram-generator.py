#!/usr/bin/env python3
"""
Database Diagram Generator
Quick tool to generate database diagrams from SQL schemas or database connections
"""

import argparse
import json
import re
import sys
from typing import Dict, List, Optional
import psycopg2
from psycopg2.extras import RealDictCursor
import matplotlib.pyplot as plt
import networkx as nx


class DatabaseDiagramGenerator:
    def __init__(self, output_format: str = "mermaid"):
        self.output_format = output_format
        self.tables = {}
        self.relationships = []

    def parse_sql_file(self, sql_file: str) -> None:
        """Parse SQL file and extract table definitions and relationships"""
        with open(sql_file, "r") as f:
            sql_content = f.read()

        # Extract table definitions
        table_pattern = r"CREATE TABLE (\w+)\s*\(([^)]+)\)"
        tables = re.findall(table_pattern, sql_content, re.IGNORECASE | re.DOTALL)

        for table_name, table_body in tables:
            self.tables[table_name] = {
                "columns": self._extract_columns(table_body),
                "constraints": self._extract_constraints(table_body),
            }

        # Extract foreign key relationships
        fk_pattern = r"FOREIGN KEY\s*\((\w+)\)\s*REFERENCES\s*(\w+)\s*\((\w+)\)"
        fks = re.findall(fk_pattern, sql_content, re.IGNORECASE)

        for fk_col, ref_table, ref_col in fks:
            self.relationships.append(
                {
                    "from_table": self._find_table_by_column(fk_col),
                    "from_column": fk_col,
                    "to_table": ref_table,
                    "to_column": ref_col,
                }
            )

    def _extract_columns(self, table_body: str) -> List[Dict]:
        """Extract column definitions from table body"""
        columns = []
        lines = table_body.split("\n")

        for line in lines:
            line = line.strip()
            if line and not line.startswith(
                ("CONSTRAINT", "PRIMARY KEY", "FOREIGN KEY", "UNIQUE", "CHECK")
            ):
                # Simple column parsing
                col_match = re.match(r"(\w+)\s+([^,]+)", line)
                if col_match:
                    col_name, col_type = col_match.groups()
                    columns.append(
                        {
                            "name": col_name,
                            "type": col_type.strip(),
                            "nullable": "NOT NULL" not in col_type.upper(),
                        }
                    )

        return columns

    def _extract_constraints(self, table_body: str) -> List[Dict]:
        """Extract constraint definitions"""
        constraints = []
        lines = table_body.split("\n")

        for line in lines:
            line = line.strip()
            if (
                line.startswith("CONSTRAINT")
                or line.startswith("PRIMARY KEY")
                or line.startswith("FOREIGN KEY")
            ):
                constraints.append({"definition": line})

        return constraints

    def _find_table_by_column(self, column_name: str) -> Optional[str]:
        """Find table name by column name"""
        for table_name, table_info in self.tables.items():
            for col in table_info["columns"]:
                if col["name"] == column_name:
                    return table_name
        return None

    def connect_to_database(self, connection_string: str) -> None:
        """Connect to database and extract schema information"""
        try:
            conn = psycopg2.connect(connection_string)
            cursor = conn.cursor(cursor_factory=RealDictCursor)

            # Get all tables
            cursor.execute("""
                SELECT table_name 
                FROM information_schema.tables 
                WHERE table_schema = 'public'
                ORDER BY table_name
            """)

            for row in cursor.fetchall():
                table_name = row["table_name"]

                # Get columns
                cursor.execute(
                    """
                    SELECT column_name, data_type, is_nullable, column_default
                    FROM information_schema.columns
                    WHERE table_name = %s AND table_schema = 'public'
                    ORDER BY ordinal_position
                """,
                    (table_name,),
                )

                columns = []
                for col in cursor.fetchall():
                    columns.append(
                        {
                            "name": col["column_name"],
                            "type": col["data_type"],
                            "nullable": col["is_nullable"] == "YES",
                            "default": col["column_default"],
                        }
                    )

                # Get foreign keys
                cursor.execute(
                    """
                    SELECT 
                        kcu.column_name,
                        ccu.table_name AS foreign_table_name,
                        ccu.column_name AS foreign_column_name
                    FROM information_schema.table_constraints AS tc
                    JOIN information_schema.key_column_usage AS kcu
                        ON tc.constraint_name = kcu.constraint_name
                    JOIN information_schema.constraint_column_usage AS ccu
                        ON ccu.constraint_name = tc.constraint_name
                    WHERE tc.constraint_type = 'FOREIGN KEY' 
                        AND tc.table_name = %s
                """,
                    (table_name,),
                )

                constraints = []
                for fk in cursor.fetchall():
                    constraints.append(
                        {
                            "type": "FOREIGN KEY",
                            "column": fk["column_name"],
                            "references_table": fk["foreign_table_name"],
                            "references_column": fk["foreign_column_name"],
                        }
                    )

                self.tables[table_name] = {
                    "columns": columns,
                    "constraints": constraints,
                }

                # Add relationships
                for constraint in constraints:
                    if constraint["type"] == "FOREIGN KEY":
                        self.relationships.append(
                            {
                                "from_table": table_name,
                                "from_column": constraint["column"],
                                "to_table": constraint["references_table"],
                                "to_column": constraint["references_column"],
                            }
                        )

            cursor.close()
            conn.close()

        except Exception as e:
            print(f"Error connecting to database: {e}")
            sys.exit(1)

    def generate_mermaid(self) -> str:
        """Generate Mermaid diagram"""
        mermaid = "```mermaid\nerDiagram\n"

        # Add tables
        for table_name, table_info in self.tables.items():
            mermaid += f"    {table_name} {{\n"

            # Add columns
            for col in table_info["columns"]:
                nullable = "" if col["nullable"] else " NOT NULL"
                mermaid += f"        {col['type']} {col['name']}{nullable}\n"

            mermaid += "    }\n\n"

        # Add relationships
        for rel in self.relationships:
            mermaid += f'    {rel["from_table"]} ||--o{{ {rel["to_table"]} : "{rel["from_column"]} -> {rel["to_column"]}"\n'

        mermaid += "```"
        return mermaid

    def generate_plantuml(self) -> str:
        """Generate PlantUML diagram"""
        plantuml = "@startuml\n!theme plain\n\n"

        # Add tables
        for table_name, table_info in self.tables.items():
            plantuml += f'entity "{table_name}" {{\n'

            # Add columns
            for col in table_info["columns"]:
                nullable = "" if col["nullable"] else " NOT NULL"
                plantuml += f"    {col['name']} : {col['type']}{nullable}\n"

            plantuml += "}\n\n"

        # Add relationships
        for rel in self.relationships:
            plantuml += f"{rel['from_table']} ||--o{{ {rel['to_table']}\n"

        plantuml += "@enduml"
        return plantuml

    def generate_matplotlib(self, output_file: str = "database_diagram.png") -> None:
        """Generate matplotlib diagram"""
        fig, ax = plt.subplots(figsize=(16, 12))

        # Create graph
        G = nx.DiGraph()

        # Add nodes (tables)
        for table_name in self.tables.keys():
            G.add_node(table_name)

        # Add edges (relationships)
        for rel in self.relationships:
            G.add_edge(rel["from_table"], rel["to_table"])

        # Layout
        pos = nx.spring_layout(G, k=3, iterations=50)

        # Draw nodes
        nx.draw_networkx_nodes(G, pos, node_color="lightblue", node_size=3000, ax=ax)

        # Draw edges
        nx.draw_networkx_edges(
            G, pos, edge_color="gray", arrows=True, arrowsize=20, ax=ax
        )

        # Draw labels
        nx.draw_networkx_labels(G, pos, font_size=8, font_weight="bold", ax=ax)

        ax.set_title("Database Schema Diagram", fontsize=16, fontweight="bold")
        ax.axis("off")

        plt.tight_layout()
        plt.savefig(output_file, dpi=300, bbox_inches="tight")
        plt.close()

        print(f"Diagram saved as {output_file}")

    def generate_json(self) -> str:
        """Generate JSON representation"""
        return json.dumps(
            {"tables": self.tables, "relationships": self.relationships}, indent=2
        )

    def generate_diagram(self, output_file: Optional[str] = None) -> str:
        """Generate diagram in specified format"""
        if self.output_format == "mermaid":
            diagram = self.generate_mermaid()
        elif self.output_format == "plantuml":
            diagram = self.generate_plantuml()
        elif self.output_format == "json":
            diagram = self.generate_json()
        elif self.output_format == "matplotlib":
            if output_file:
                self.generate_matplotlib(output_file)
            else:
                self.generate_matplotlib()
            return "Diagram generated successfully"
        else:
            raise ValueError(f"Unsupported format: {self.output_format}")

        if output_file:
            with open(output_file, "w") as f:
                f.write(diagram)
            print(f"Diagram saved as {output_file}")

        return diagram


def main():
    parser = argparse.ArgumentParser(
        description="Generate database diagrams from SQL files or database connections"
    )
    parser.add_argument("--sql-file", help="SQL file to parse")
    parser.add_argument("--db-connection", help="Database connection string")
    parser.add_argument(
        "--format",
        choices=["mermaid", "plantuml", "json", "matplotlib"],
        default="mermaid",
        help="Output format",
    )
    parser.add_argument("--output", help="Output file path")

    args = parser.parse_args()

    if not args.sql_file and not args.db_connection:
        print("Error: Must provide either --sql-file or --db-connection")
        sys.exit(1)

    generator = DatabaseDiagramGenerator(args.format)

    if args.sql_file:
        generator.parse_sql_file(args.sql_file)
    elif args.db_connection:
        generator.connect_to_database(args.db_connection)

    diagram = generator.generate_diagram(args.output)

    if not args.output:
        print(diagram)


if __name__ == "__main__":
    main()
