# Assets Directory

This directory contains all visual assets for the HR Intelligence Platform documentation.

## Directory Structure

```
assets/
├── diagrams/
│   ├── architecture/     # System architecture, API flows, deployment diagrams
│   ├── workflows/        # User flows, process diagrams, journey maps
│   └── business-model/   # Revenue models, market analysis, ROI visualizations
├── mockups/
│   ├── dashboard/        # Web dashboard screens, analytics views
│   └── mobile/           # Mobile app screens, responsive designs
├── icons/                # Icons, logos, visual elements
├── templates/            # Document templates, presentation formats
└── README.md             # This file
```

## Asset Guidelines

### Diagrams
- **Format:** SVG (preferred) or PNG for complex diagrams
- **Naming:** Use descriptive names with underscores (e.g., `system_architecture.svg`)
- **Size:** Optimize for web viewing (max 1200px width)
- **Tools:** Draw.io, Lucidchart, or Figma

### Mockups
- **Format:** PNG or JPG for screenshots, Figma links for interactive designs
- **Naming:** Include screen name and version (e.g., `dashboard_home_v2.png`)
- **Size:** Maintain aspect ratios, optimize file sizes
- **Tools:** Figma, Sketch, or Adobe XD

### Icons
- **Format:** SVG (preferred) or PNG for complex icons
- **Naming:** Use semantic names (e.g., `alert_critical.svg`)
- **Size:** 16px, 24px, 32px, 64px variants
- **Tools:** Figma, Sketch, or icon libraries

## Priority Visual Assets to Create

Based on the reorganized documentation, these are the highest-priority visual assets needed:

### From Technical Architecture (`diagrams/architecture/`)
- [ ] **System Architecture Overview** - Multi-service architecture with data flows
- [ ] **Predictive Intelligence Pipeline** - ML processing and scoring workflow  
- [ ] **API Endpoint Map** - RESTful API structure and relationships
- [ ] **Database Schema** - PostgreSQL tables and relationships
- [ ] **BLS Integration Flow** - Skills mapping and job requirement analysis

### From User Workflows (`diagrams/workflows/`, `mockups/dashboard/`)
- [ ] **HR Manager Daily Workflow** - 5-minute monitoring process
- [ ] **Executive Dashboard Mockup** - C-suite metrics and KPI views
- [ ] **Store Manager Mobile Flow** - Weekly team review process
- [ ] **Regional Director Comparison View** - Multi-location performance dashboard
- [ ] **Employee Profile Detail Screen** - Individual readiness scores and programs

### From Business Model (`diagrams/business-model/`)
- [ ] **Revenue Model Visualization** - Pay-per-use pricing structure
- [ ] **Market Opportunity Funnel** - TAM → SAM → SOM progression
- [ ] **ROI Calculation Framework** - Visual formula and example calculations
- [ ] **Competitive Positioning Map** - Feature comparison and market placement
- [ ] **Implementation Timeline** - 90-day deployment phases

### From Implementation Guide (`diagrams/workflows/`)
- [ ] **HRIS Integration Flow** - Auto-sync and prediction updates
- [ ] **Alert Escalation Workflow** - Priority levels and response times
- [ ] **Deployment Architecture** - Infrastructure components and scaling

### Mobile Experience (`mockups/mobile/`)
- [ ] **Manager Mobile Dashboard** - Key metrics on mobile screen
- [ ] **Employee Assessment Flow** - Vision board + game interface
- [ ] **Alert Notification System** - Mobile-first alert management

## Conversion Priority

**Phase 1 (High Priority):**
1. System Architecture Overview
2. HR Manager Daily Workflow  
3. Revenue Model Visualization
4. Executive Dashboard Mockup

**Phase 2 (Medium Priority):**
5. Predictive Intelligence Pipeline
6. ROI Calculation Framework
7. Store Manager Mobile Flow
8. HRIS Integration Flow

**Phase 3 (Nice to Have):**
9. Database Schema
10. Competitive Positioning Map
11. Employee Profile Detail Screen
12. Alert Escalation Workflow

## Asset Management

- Keep file sizes under 2MB for web optimization
- Use consistent color schemes across all assets
- Include alt text descriptions for accessibility
- Version control all assets with descriptive commit messages
- Maintain a style guide for visual consistency