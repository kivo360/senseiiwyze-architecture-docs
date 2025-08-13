# Quick Database Diagram Example

## Generate Mermaid Diagram from SQL File

```bash
# Install dependencies
pip install -r senseiwyze-conf-requirements.txt

# Generate Mermaid diagram
python database-diagram-generator.py \
  --sql-file senseiwyze-data-prediction-schema.sql \
  --format mermaid \
  --output senseiiwyze-schema.md
```

## Example Output

```mermaid
erDiagram
    profiles {
        uuid id PK
        text email
        text name
        text workplace
        enum user_role
        text employment_status
        text profile_photo
    }

    vision_boards {
        uuid id PK
        uuid profile_id FK
        jsonb board_data
        timestamp created_at
        timestamp updated_at
    }

    vision_board_analysis {
        uuid id PK
        uuid vision_board_id FK
        jsonb tech_objects_detected
        jsonb professional_scenes
        jsonb education_symbols
        jsonb color_psychology
        text[] dominant_colors
        text extracted_text
        integer specificity_score
        text timeline_extracted
        decimal sentiment_score
        integer vision_score
        text analysis_model_version
        integer processing_time_ms
        decimal confidence_score
        timestamp created_at
        timestamp updated_at
    }

    cognitive_scores {
        uuid id PK
        uuid profile_id FK
        enum assessment_type
        integer raw_score
        decimal normalized_score
        decimal persistence_rate
        decimal improvement_curve
        integer streak_consistency
        decimal puzzle_accuracy
        integer pattern_recognition_speed
        decimal strategic_moves_ratio
        decimal sequence_completion_rate
        decimal efficiency_rating
        decimal abstraction_ability
        integer assessment_duration_seconds
        text difficulty_level
        uuid game_session_id
        timestamp created_at
    }

    personality_assessments {
        uuid id PK
        uuid profile_id FK
        integer openness_score
        integer conscientiousness_score
        integer extraversion_score
        integer agreeableness_score
        integer neuroticism_score
        integer stress_management_score
        decimal collaboration_readiness
        text learning_style
        text assessment_version
        integer completion_time_minutes
        decimal confidence_level
        timestamp created_at
    }

    training_programs {
        uuid id PK
        text program_name
        text program_code
        integer duration_weeks_min
        integer duration_weeks_max
        text description
        text[] prerequisites
        integer vision_score_min
        integer grit_score_min
        integer logic_score_min
        integer algorithm_score_min
        decimal vision_weight
        decimal grit_weight
        decimal logic_weight
        decimal algorithm_weight
        text[] industry_focus
        text difficulty_level
        boolean certification_offered
        decimal job_placement_rate
        decimal base_price
        jsonb payment_plans
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }

    training_readiness_predictions {
        uuid id PK
        uuid profile_id FK
        uuid training_program_id FK
        decimal readiness_score
        decimal confidence_level
        text prediction_category
        decimal cognitive_readiness
        integer life_circumstances_score
        decimal motivation_alignment
        decimal time_pressure_modifier
        text[] risk_factors
        boolean intervention_needed
        text[] intervention_types
        integer predicted_completion_weeks
        decimal predicted_completion_rate
        decimal predicted_dropout_risk
        text model_version
        jsonb feature_vector
        timestamp created_at
        timestamp valid_until
    }

    life_circumstances {
        uuid id PK
        uuid profile_id FK
        text employment_status
        boolean job_flexibility
        integer financial_security_months
        boolean family_support_available
        text study_environment_quality
        text technology_access
        boolean childcare_responsibilities
        boolean eldercare_responsibilities
        integer commute_time_minutes
        text work_schedule_flexibility
        integer overall_stability_score
        timestamp created_at
        timestamp updated_at
    }

    intervention_types {
        uuid id PK
        text intervention_name
        text category
        text description
        integer duration_weeks
        decimal cost_per_participant
        integer expected_improvement_points
        text[] target_cognitive_areas
        text[] target_personality_traits
        text[] target_life_circumstances
        boolean is_active
        timestamp created_at
    }

    user_interventions {
        uuid id PK
        uuid profile_id FK
        uuid intervention_type_id FK
        uuid assigned_by FK
        text status
        date start_date
        date completion_date
        date actual_completion_date
        jsonb pre_intervention_scores
        jsonb post_intervention_scores
        decimal improvement_achieved
        text coach_notes
        text participant_feedback
        timestamp created_at
        timestamp updated_at
    }

    program_enrollments {
        uuid id PK
        uuid profile_id FK
        uuid training_program_id FK
        date enrollment_date
        date predicted_completion_date
        date actual_completion_date
        text enrollment_status
        integer current_week
        decimal completion_percentage
        date last_activity_date
        decimal final_grade
        boolean certification_earned
        date job_placement_date
        decimal starting_salary
        uuid original_prediction_id FK
        decimal prediction_accuracy
        timestamp created_at
        timestamp updated_at
    }

    kpi_metrics {
        uuid id PK
        text metric_name
        text metric_category
        decimal metric_value
        decimal target_value
        decimal previous_value
        date calculation_date
        text cohort_identifier
        text calculation_method
        text data_source
        timestamp created_at
    }

    profiles ||--o{ vision_boards : "profile_id"
    vision_boards ||--o{ vision_board_analysis : "vision_board_id"
    profiles ||--o{ cognitive_scores : "profile_id"
    profiles ||--o{ personality_assessments : "profile_id"
    profiles ||--o{ life_circumstances : "profile_id"
    profiles ||--o{ training_readiness_predictions : "profile_id"
    training_programs ||--o{ training_readiness_predictions : "training_program_id"
    profiles ||--o{ user_interventions : "profile_id"
    intervention_types ||--o{ user_interventions : "intervention_type_id"
    profiles ||--o{ user_interventions : "assigned_by"
    profiles ||--o{ program_enrollments : "profile_id"
    training_programs ||--o{ program_enrollments : "training_program_id"
    training_readiness_predictions ||--o{ program_enrollments : "original_prediction_id"
```

## Generate from Live Database

```bash
# Connect to your Supabase database
python database-diagram-generator.py \
  --db-connection "postgresql://postgres:[password]@db.[project-ref].supabase.co:5432/postgres" \
  --format mermaid \
  --output live-schema.md
```

## Generate Visual Diagram

```bash
# Create PNG diagram
python database-diagram-generator.py \
  --sql-file senseiwyze-data-prediction-schema.sql \
  --format matplotlib \
  --output senseiiwyze-schema.png
```

## Generate JSON Schema

```bash
# Export as JSON for API documentation
python database-diagram-generator.py \
  --sql-file senseiwyze-data-prediction-schema.sql \
  --format json \
  --output schema.json
```

## Integration with Documentation

You can now include the generated Mermaid diagram in your documentation:

```markdown
# SenseiiWyze Database Schema

## Entity Relationship Diagram

[Include the generated Mermaid diagram here]

## Table Descriptions

### Core Tables
- **profiles**: User account information
- **vision_boards**: User-created vision boards
- **cognitive_scores**: Detailed cognitive assessment results
- **personality_assessments**: OCEAN personality model scores
- **training_programs**: Available training programs with requirements
- **training_readiness_predictions**: AI-generated readiness predictions

### Supporting Tables
- **vision_board_analysis**: Computer vision analysis results
- **life_circumstances**: User life situation assessment
- **intervention_types**: Available coaching interventions
- **user_interventions**: Assigned coaching sessions
- **program_enrollments**: Training program enrollments
- **kpi_metrics**: System performance tracking
```

This provides a quick way to visualize and document your database schema for the SenseiiWyze system! 