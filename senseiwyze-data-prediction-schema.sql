-- =====================================================
-- SenseiiWyze Training Readiness Prediction System
-- Database Integration Schema
-- =====================================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- =====================================================
-- 1. ENHANCED VISION BOARD ANALYSIS
-- =====================================================

-- Computer Vision Analysis Results
CREATE TABLE vision_board_analysis (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vision_board_id UUID REFERENCES vision_boards(id) ON DELETE CASCADE,

-- Object Detection Results
tech_objects_detected JSONB, -- {laptop: true, certificate: false, money: true}
professional_scenes JSONB, -- {office: 0.8, home: 0.2, outdoor: 0.0}
education_symbols JSONB, -- {diploma: true, books: false, graduation: true}

-- Color Analysis
color_psychology JSONB,      -- {blue: 0.35, green: 0.25, purple: 0.15, red: 0.10, grey: 0.15}
    dominant_colors TEXT[],      -- ['blue', 'green', 'purple']

-- Text Analysis
extracted_text TEXT,
specificity_score INTEGER CHECK (
    specificity_score >= 0
    AND specificity_score <= 10
),
timeline_extracted TEXT, -- 'immediate', 'short-term', 'long-term'
sentiment_score DECIMAL(3, 2), -- -1.0 to 1.0

-- Overall Vision Score
vision_score INTEGER CHECK (
    vision_score >= 0
    AND vision_score <= 100
),

-- Analysis Metadata
analysis_model_version TEXT,
    processing_time_ms INTEGER,
    confidence_score DECIMAL(3,2),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Vision Board Templates for Guidance
CREATE TABLE vision_board_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    template_name TEXT NOT NULL,
    template_description TEXT,
    category TEXT, -- 'tech-career', 'entrepreneurial', 'academic', 'personal-growth'

-- Template Structure
suggested_objects JSONB,
recommended_colors JSONB,
example_text TEXT,

-- Success Metrics
avg_vision_score INTEGER,
    completion_rate DECIMAL(5,2),
    
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 2. ENHANCED COGNITIVE SCORING SYSTEM
-- =====================================================

-- Cognitive Assessment Types
CREATE TYPE cognitive_assessment_type AS ENUM (
    'grit', 'logic', 'algorithm', 'memory', 'pattern_recognition', 
    'strategic_thinking', 'problem_solving', 'attention'
);

-- Enhanced Cognitive Scores
CREATE TABLE cognitive_scores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    assessment_type cognitive_assessment_type NOT NULL,

-- Detailed Scoring Components
raw_score INTEGER CHECK (
    raw_score >= 0
    AND raw_score <= 100
),
normalized_score DECIMAL(5, 2) CHECK (
    normalized_score >= 0
    AND normalized_score <= 100
),

-- Component Breakdown
persistence_rate DECIMAL(5, 2), -- For grit
improvement_curve DECIMAL(5, 2), -- Learning rate
streak_consistency INTEGER, -- Consecutive days
puzzle_accuracy DECIMAL(5, 2), -- For logic
pattern_recognition_speed INTEGER, -- Milliseconds
strategic_moves_ratio DECIMAL(5, 2), -- Optimal vs actual
sequence_completion_rate DECIMAL(5, 2), -- For algorithms
efficiency_rating DECIMAL(5, 2), -- Steps used vs minimum
abstraction_ability DECIMAL(5, 2), -- Pattern application

-- Assessment Metadata
assessment_duration_seconds INTEGER,
difficulty_level TEXT, -- 'easy', 'medium', 'hard', 'adaptive'
game_session_id UUID,
created_at TIMESTAMP
WITH
    TIME ZONE DEFAULT NOW(),

-- Ensure one score per assessment type per user per day
CONSTRAINT unique_daily_cognitive_score 
        UNIQUE (profile_id, assessment_type, DATE(created_at))
);

-- Cognitive Assessment Sessions

CREATE TABLE cognitive_assessment_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    
    session_type TEXT, -- 'initial', 'progress', 'final'
    total_duration_seconds INTEGER,
    games_completed INTEGER,
    overall_score DECIMAL(5,2),

-- Session Context
device_type TEXT, -- 'desktop', 'mobile', 'tablet'
    browser_info TEXT,
    network_quality TEXT, -- 'good', 'fair', 'poor'
    
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,
    
    CONSTRAINT valid_completion_time CHECK (completed_at IS NULL OR completed_at >= started_at)
);

-- =====================================================
-- 3. PERSONALITY ASSESSMENT SYSTEM
-- =====================================================

-- OCEAN Personality Model
CREATE TABLE personality_assessments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,

-- OCEAN Scores (0-100)
openness_score INTEGER CHECK (
    openness_score >= 0
    AND openness_score <= 100
),
conscientiousness_score INTEGER CHECK (
    conscientiousness_score >= 0
    AND conscientiousness_score <= 100
),
extraversion_score INTEGER CHECK (
    extraversion_score >= 0
    AND extraversion_score <= 100
),
agreeableness_score INTEGER CHECK (
    agreeableness_score >= 0
    AND agreeableness_score <= 100
),
neuroticism_score INTEGER CHECK (
    neuroticism_score >= 0
    AND neuroticism_score <= 100
),

-- Derived Metrics
stress_management_score INTEGER CHECK (
    stress_management_score >= 0
    AND stress_management_score <= 100
),
collaboration_readiness DECIMAL(5, 2),
learning_style TEXT, -- 'visual', 'auditory', 'kinesthetic', 'mixed'

-- Assessment Context
assessment_version TEXT,
completion_time_minutes INTEGER,
confidence_level DECIMAL(3, 2), -- 0.0 to 1.0
created_at TIMESTAMP
WITH
    TIME ZONE DEFAULT NOW(),

-- One assessment per user per month
CONSTRAINT unique_monthly_personality_assessment 
        UNIQUE (profile_id, DATE_TRUNC('month', created_at))
);

-- Personality-Based Recommendations

CREATE TABLE personality_recommendations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    personality_assessment_id UUID REFERENCES personality_assessments(id) ON DELETE CASCADE,
    
    recommended_training_paths TEXT[],
    learning_style_adaptations JSONB,
    collaboration_preferences JSONB,
    stress_management_strategies TEXT[],
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 4. TRAINING PROGRAMS & REQUIREMENTS
-- =====================================================

-- Training Program Definitions
CREATE TABLE training_programs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    program_name TEXT NOT NULL UNIQUE,
    program_code TEXT NOT NULL UNIQUE, -- 'CISCO_DA', 'CISCO_CYBER', etc.

-- Program Details
duration_weeks_min INTEGER,
    duration_weeks_max INTEGER,
    description TEXT,
    prerequisites TEXT[],

-- Success Requirements (Thresholds)
vision_score_min INTEGER CHECK (
    vision_score_min >= 0
    AND vision_score_min <= 100
),
grit_score_min INTEGER CHECK (
    grit_score_min >= 0
    AND grit_score_min <= 100
),
logic_score_min INTEGER CHECK (
    logic_score_min >= 0
    AND logic_score_min <= 100
),
algorithm_score_min INTEGER CHECK (
    algorithm_score_min >= 0
    AND algorithm_score_min <= 100
),

-- Weight Factors for Prediction
vision_weight DECIMAL(3, 2) DEFAULT 0.25,
grit_weight DECIMAL(3, 2) DEFAULT 0.30,
logic_weight DECIMAL(3, 2) DEFAULT 0.20,
algorithm_weight DECIMAL(3, 2) DEFAULT 0.25,

-- Program Metadata
industry_focus TEXT[], -- ['data-analytics', 'cybersecurity', 'networking']
    difficulty_level TEXT, -- 'beginner', 'intermediate', 'advanced'
    certification_offered BOOLEAN DEFAULT false,
    job_placement_rate DECIMAL(5,2),

-- Pricing
base_price DECIMAL(10,2),
    payment_plans JSONB,
    
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 5. PREDICTION ENGINE
-- =====================================================

-- Training Readiness Predictions
CREATE TABLE training_readiness_predictions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    training_program_id UUID REFERENCES training_programs(id) ON DELETE CASCADE,

-- Prediction Scores
readiness_score DECIMAL(5, 2) CHECK (
    readiness_score >= 0
    AND readiness_score <= 100
),
confidence_level DECIMAL(3, 2) CHECK (
    confidence_level >= 0
    AND confidence_level <= 1
),

-- Prediction Category
prediction_category TEXT CHECK (
    prediction_category IN (
        'ready_to_enroll',
        'ready_with_support',
        'almost_ready',
        'needs_preparation',
        'not_ready'
    )
),

-- Detailed Scoring
cognitive_readiness DECIMAL(5, 2),
life_circumstances_score INTEGER CHECK (
    life_circumstances_score >= 0
    AND life_circumstances_score <= 100
),
motivation_alignment DECIMAL(3, 2),
time_pressure_modifier DECIMAL(3, 2),

-- Risk Factors
risk_factors TEXT[],
    intervention_needed BOOLEAN DEFAULT false,
    intervention_types TEXT[],

-- Predicted Outcomes
predicted_completion_weeks INTEGER,
predicted_completion_rate DECIMAL(5, 2),
predicted_dropout_risk DECIMAL(5, 2),

-- Model Information
model_version TEXT,
feature_vector JSONB, -- 47-dimensional feature vector
created_at TIMESTAMP
WITH
    TIME ZONE DEFAULT NOW(),
    valid_until TIMESTAMP
WITH
    TIME ZONE,

-- One prediction per user per program per day
CONSTRAINT unique_daily_prediction 
        UNIQUE (profile_id, training_program_id, DATE(created_at))
);

-- Life Circumstances Assessment
CREATE TABLE life_circumstances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,

-- Stability Factors
employment_status TEXT, -- 'employed', 'unemployed', 'part_time', 'student'
job_flexibility BOOLEAN,
financial_security_months INTEGER,
family_support_available BOOLEAN,
study_environment_quality TEXT, -- 'excellent', 'good', 'fair', 'poor'
technology_access TEXT, -- 'excellent', 'good', 'fair', 'poor'

-- Additional Context
childcare_responsibilities BOOLEAN,
eldercare_responsibilities BOOLEAN,
commute_time_minutes INTEGER,
work_schedule_flexibility TEXT, -- 'very_flexible', 'flexible', 'rigid'

-- Calculated Score
overall_stability_score INTEGER CHECK (overall_stability_score >= 0 AND overall_stability_score <= 100),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 6. INTERVENTION & COACHING SYSTEM
-- =====================================================

-- Intervention Types

CREATE TABLE intervention_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    intervention_name TEXT NOT NULL UNIQUE,
    category TEXT, -- 'cognitive', 'motivational', 'logistical', 'social'
    
    description TEXT,
    duration_weeks INTEGER,
    cost_per_participant DECIMAL(8,2),
    expected_improvement_points INTEGER,

-- Target Areas
target_cognitive_areas TEXT[],
    target_personality_traits TEXT[],
    target_life_circumstances TEXT[],
    
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User Interventions
CREATE TABLE user_interventions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    intervention_type_id UUID REFERENCES intervention_types(id) ON DELETE CASCADE,
    assigned_by UUID REFERENCES profiles(id),

-- Intervention Details
status TEXT CHECK (
    status IN (
        'assigned',
        'in_progress',
        'completed',
        'cancelled'
    )
),
start_date DATE,
completion_date DATE,
actual_completion_date DATE,

-- Progress Tracking
pre_intervention_scores JSONB,
post_intervention_scores JSONB,
improvement_achieved DECIMAL(5, 2),

-- Coaching Notes
coach_notes TEXT,
    participant_feedback TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 7. ENROLLMENT & OUTCOME TRACKING
-- =====================================================

-- Program Enrollments
CREATE TABLE program_enrollments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    training_program_id UUID REFERENCES training_programs(id) ON DELETE CASCADE,

-- Enrollment Details
enrollment_date DATE NOT NULL,
predicted_completion_date DATE,
actual_completion_date DATE,

-- Status Tracking
enrollment_status TEXT CHECK (
    enrollment_status IN (
        'enrolled',
        'in_progress',
        'completed',
        'dropped_out',
        'transferred'
    )
),

-- Progress Metrics
current_week INTEGER,
completion_percentage DECIMAL(5, 2),
last_activity_date DATE,

-- Outcome Data
final_grade DECIMAL(5, 2),
certification_earned BOOLEAN,
job_placement_date DATE,
starting_salary DECIMAL(10, 2),

-- Prediction Accuracy
original_prediction_id UUID REFERENCES training_readiness_predictions(id),
    prediction_accuracy DECIMAL(5,2),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 8. ANALYTICS & REPORTING
-- =====================================================

-- KPI Tracking
CREATE TABLE kpi_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    metric_name TEXT NOT NULL,
    metric_category TEXT, -- 'prediction', 'enrollment', 'completion', 'business'

-- Metric Values
metric_value DECIMAL(10, 2),
target_value DECIMAL(10, 2),
previous_value DECIMAL(10, 2),

-- Context
calculation_date DATE NOT NULL,
cohort_identifier TEXT, -- 'all_users', 'new_enrollments', 'specific_program'

-- Metadata
calculation_method TEXT,
data_source TEXT,
created_at TIMESTAMP
WITH
    TIME ZONE DEFAULT NOW(),

-- One metric per name per date per cohort
CONSTRAINT unique_daily_kpi 
        UNIQUE (metric_name, calculation_date, cohort_identifier)
);

-- =====================================================
-- 9. INDEXES FOR PERFORMANCE
-- =====================================================

-- Vision Board Analysis Indexes
CREATE INDEX idx_vision_board_analysis_board_id ON vision_board_analysis (vision_board_id);

CREATE INDEX idx_vision_board_analysis_score ON vision_board_analysis (vision_score);

CREATE INDEX idx_vision_board_analysis_created ON vision_board_analysis (created_at);

-- Cognitive Scores Indexes
CREATE INDEX idx_cognitive_scores_profile_type ON cognitive_scores (profile_id, assessment_type);

CREATE INDEX idx_cognitive_scores_created ON cognitive_scores (created_at);

CREATE INDEX idx_cognitive_scores_normalized ON cognitive_scores (normalized_score);

-- Personality Assessments Indexes
CREATE INDEX idx_personality_profile_created ON personality_assessments (profile_id, created_at);

CREATE INDEX idx_personality_openness ON personality_assessments (openness_score);

CREATE INDEX idx_personality_conscientiousness ON personality_assessments (conscientiousness_score);

-- Predictions Indexes
CREATE INDEX idx_predictions_profile_program ON training_readiness_predictions (
    profile_id,
    training_program_id
);

CREATE INDEX idx_predictions_score ON training_readiness_predictions (readiness_score);

CREATE INDEX idx_predictions_category ON training_readiness_predictions (prediction_category);

CREATE INDEX idx_predictions_created ON training_readiness_predictions (created_at);

-- Enrollments Indexes
CREATE INDEX idx_enrollments_profile ON program_enrollments (profile_id);

CREATE INDEX idx_enrollments_program ON program_enrollments (training_program_id);

CREATE INDEX idx_enrollments_status ON program_enrollments (enrollment_status);

CREATE INDEX idx_enrollments_date ON program_enrollments (enrollment_date);

-- =====================================================
-- 10. TRIGGERS FOR AUTOMATION
-- =====================================================

-- Update timestamps automatically
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply triggers to tables with updated_at columns
CREATE TRIGGER update_vision_board_analysis_updated_at 
    BEFORE UPDATE ON vision_board_analysis 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_training_programs_updated_at 
    BEFORE UPDATE ON training_programs 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_life_circumstances_updated_at 
    BEFORE UPDATE ON life_circumstances 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_interventions_updated_at 
    BEFORE UPDATE ON user_interventions 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_program_enrollments_updated_at 
    BEFORE UPDATE ON program_enrollments 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 11. SAMPLE DATA INSERTION
-- =====================================================

-- Insert sample training programs
INSERT INTO training_programs (
    program_name, program_code, duration_weeks_min, duration_weeks_max,
    vision_score_min, grit_score_min, logic_score_min, algorithm_score_min,
    industry_focus, difficulty_level, base_price
) VALUES 
    ('Cisco Data Analytics', 'CISCO_DA', 32, 40, 70, 65, 80, 70, 
     ARRAY['data-analytics'], 'intermediate', 8999.00),
    ('Cisco Cybersecurity Operations', 'CISCO_CYBER', 36, 44, 65, 75, 70, 80,
     ARRAY['cybersecurity'], 'intermediate', 9999.00),
    ('Cisco Network Engineering', 'CISCO_NET', 40, 48, 70, 75, 75, 85,
     ARRAY['networking'], 'advanced', 11999.00),
    ('Cisco IoT Tech Support', 'CISCO_IOT', 28, 36, 60, 70, 65, 70,
     ARRAY['iot', 'support'], 'beginner', 6999.00),
    ('IBM AI & Machine Learning', 'IBM_AI_ML', 44, 48, 80, 80, 85, 90,
     ARRAY['ai', 'machine-learning'], 'advanced', 14999.00);

-- Insert sample intervention types
INSERT INTO intervention_types (
    intervention_name, category, description, duration_weeks,
    cost_per_participant, expected_improvement_points, target_cognitive_areas
) VALUES 
    ('Logic Bootcamp', 'cognitive', 'Intensive logic and problem-solving training', 2,
     500.00, 12, ARRAY['logic', 'algorithm']),
    ('Goal Setting Workshop', 'motivational', 'Vision board optimization and goal clarity', 1,
     200.00, 8, ARRAY['vision']),
    ('Study Skills Enhancement', 'cognitive', 'Time management and learning strategies', 3,
     750.00, 15, ARRAY['grit', 'logic']),
    ('Stress Management Program', 'motivational', 'Coping strategies for high-pressure learning', 2,
     400.00, 10, ARRAY['neuroticism']);

-- =====================================================
-- 12. VIEWS FOR ANALYTICS
-- =====================================================

-- User Readiness Summary View
CREATE VIEW user_readiness_summary AS
SELECT p.id as profile_id, p.name, p.email, p.workplace,

-- Latest cognitive scores
cs_grit.normalized_score as grit_score,
cs_logic.normalized_score as logic_score,
cs_algorithm.normalized_score as algorithm_score,

-- Latest vision score
vba.vision_score,

-- Latest personality scores
pa.openness_score,
pa.conscientiousness_score,
pa.extraversion_score,
pa.agreeableness_score,
pa.neuroticism_score,

-- Life circumstances
lc.overall_stability_score,

-- Best program match
trp.training_program_id,
tp.program_name,
trp.readiness_score,
trp.prediction_category,
trp.predicted_completion_weeks
FROM
    profiles p
    LEFT JOIN LATERAL (
        SELECT *
        FROM cognitive_scores
        WHERE
            profile_id = p.id
            AND assessment_type = 'grit'
        ORDER BY created_at DESC
        LIMIT 1
    ) cs_grit ON true
    LEFT JOIN LATERAL (
        SELECT *
        FROM cognitive_scores
        WHERE
            profile_id = p.id
            AND assessment_type = 'logic'
        ORDER BY created_at DESC
        LIMIT 1
    ) cs_logic ON true
    LEFT JOIN LATERAL (
        SELECT *
        FROM cognitive_scores
        WHERE
            profile_id = p.id
            AND assessment_type = 'algorithm'
        ORDER BY created_at DESC
        LIMIT 1
    ) cs_algorithm ON true
    LEFT JOIN LATERAL (
        SELECT vba.*
        FROM
            vision_board_analysis vba
            JOIN vision_boards vb ON vba.vision_board_id = vb.id
        WHERE
            vb.profile_id = p.id
        ORDER BY vba.created_at DESC
        LIMIT 1
    ) vba ON true
    LEFT JOIN LATERAL (
        SELECT *
        FROM personality_assessments
        WHERE
            profile_id = p.id
        ORDER BY created_at DESC
        LIMIT 1
    ) pa ON true
    LEFT JOIN LATERAL (
        SELECT *
        FROM life_circumstances
        WHERE
            profile_id = p.id
        ORDER BY created_at DESC
        LIMIT 1
    ) lc ON true
    LEFT JOIN LATERAL (
        SELECT *
        FROM training_readiness_predictions
        WHERE
            profile_id = p.id
        ORDER BY readiness_score DESC
        LIMIT 1
    ) trp ON true
    LEFT JOIN training_programs tp ON trp.training_program_id = tp.id;

-- Program Success Analytics View

CREATE VIEW program_success_analytics AS
SELECT 
    tp.program_name,
    tp.program_code,
    COUNT(pe.id) as total_enrollments,
    COUNT(CASE WHEN pe.enrollment_status = 'completed' THEN 1 END) as completions,
    COUNT(CASE WHEN pe.enrollment_status = 'dropped_out' THEN 1 END) as dropouts,
    ROUND(
        COUNT(CASE WHEN pe.enrollment_status = 'completed' THEN 1 END)::DECIMAL / 
        COUNT(pe.id) * 100, 2
    ) as completion_rate,
    AVG(pe.completion_percentage) as avg_completion_percentage,
    AVG(pe.final_grade) as avg_final_grade,
    AVG(pe.starting_salary) as avg_starting_salary,
    AVG(trp.readiness_score) as avg_readiness_score,
    AVG(trp.prediction_accuracy) as avg_prediction_accuracy
    
FROM training_programs tp
LEFT JOIN program_enrollments pe ON tp.id = pe.training_program_id
LEFT JOIN training_readiness_predictions trp ON pe.original_prediction_id = trp.id
GROUP BY tp.id, tp.program_name, tp.program_code;

-- =====================================================
-- END OF SCHEMA
-- =====================================================