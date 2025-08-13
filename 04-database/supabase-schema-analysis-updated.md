# Supabase Database Schema Analysis Report - Updated

**Generated Date:** 2025-01-27  
**Project:** `mtzwzsxblhulourliqvr` (SenseiiWyze - Test Site)  
**Database Host:** db.mtzwzsxblhulourliqvr.supabase.co  
**PostgreSQL Version:** 15.1.0.153

---

## Executive Summary

This updated report provides a comprehensive analysis of the Supabase project `mtzwzsxblhulourliqvr` with example data structures for each table. The database contains 48 tables representing a sophisticated SaaS learning management platform with advanced features including billing, RBAC, communication tools, and gamification.

---

## Database Schema Overview

### Core Table Categories

#### 🔑 User Management & Authentication

**`profiles`** - Primary user table
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "john.doe@company.com",
  "name": "John Doe",
  "workplace": "Acme Corp",
  "user_role": "employee",
  "employment_status": "full_time",
  "profile_photo": "https://storage.supabase.co/photos/john-doe.jpg",
  "topPos": 100,
  "bottomPos": 200,
  "leftPos": 150,
  "rightPos": 250,
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-20T14:45:00Z"
}
```

**`accounts`** - Primary tenant boundary
```json
{
  "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "name": "Acme Corporation",
  "type": "business",
  "public_data": {
    "industry": "Technology",
    "size": "500-1000",
    "location": "San Francisco, CA"
  },
  "picture_url": "https://storage.supabase.co/logos/acme-corp.png",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-15T12:00:00Z"
}
```

**`accounts_memberships`** - User-account relationships
```json
{
  "id": "b2c3d4e5-f6g7-8901-bcde-f23456789012",
  "account_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "role_id": "role-admin-123",
  "status": "active",
  "joined_at": "2024-01-15T10:30:00Z",
  "created_at": "2024-01-15T10:30:00Z"
}
```

**`roles`** - Role definitions
```json
{
  "id": "role-admin-123",
  "name": "Administrator",
  "description": "Full system access",
  "level": 1,
  "account_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "created_at": "2024-01-01T00:00:00Z"
}
```

#### 📋 Assessment System

**`assessments`** - Assessment templates
```json
{
  "id": "assessment-123",
  "title": "Leadership Competency Assessment",
  "description": "Comprehensive leadership skills evaluation",
  "metadata": {
    "duration_minutes": 45,
    "question_count": 25,
    "categories": ["leadership", "communication", "decision_making"]
  },
  "strategy": {
    "scoring_method": "weighted_average",
    "passing_threshold": 70
  },
  "cover_image": "https://storage.supabase.co/assessments/leadership-cover.jpg",
  "account_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "created_at": "2024-01-10T09:00:00Z"
}
```

**`questions`** - Assessment questions
```json
{
  "id": "question-456",
  "assessment_id": "assessment-123",
  "question_text": "How do you typically handle team conflicts?",
  "question_type": "multiple_choice",
  "options": [
    {"value": "A", "text": "Avoid the conflict"},
    {"value": "B", "text": "Address it immediately"},
    {"value": "C", "text": "Seek mediation"},
    {"value": "D", "text": "Let it resolve naturally"}
  ],
  "correct_answer": "B",
  "weight": 1.0,
  "created_at": "2024-01-10T09:15:00Z"
}
```

**`evaluations`** - User assessment attempts
```json
{
  "id": "eval-789",
  "assessment_id": "assessment-123",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "status": "completed",
  "score": 85.5,
  "started_at": "2024-01-20T14:00:00Z",
  "completed_at": "2024-01-20T14:35:00Z",
  "created_at": "2024-01-20T14:00:00Z"
}
```

**`answers`** - User responses to questions
```json
{
  "id": "answer-101",
  "question_id": "question-456",
  "evaluation_id": "eval-789",
  "selected_answer": "B",
  "is_correct": true,
  "time_taken_seconds": 45,
  "created_at": "2024-01-20T14:05:00Z"
}
```

#### 🎮 Gamification Engine

**`activities`** - Learning activities
```json
{
  "id": "activity-202",
  "title": "Team Building Challenge",
  "description": "Collaborative problem-solving activity",
  "activity_type": "collaborative",
  "difficulty_level": "intermediate",
  "estimated_duration": 30,
  "max_participants": 8,
  "category_id": "category-team-building",
  "account_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "created_at": "2024-01-15T11:00:00Z"
}
```

**`tasks`** - Activity tasks
```json
{
  "id": "task-303",
  "activity_id": "activity-202",
  "title": "Build the tallest tower",
  "description": "Using only paper and tape, build the tallest stable tower",
  "task_type": "physical",
  "duration_minutes": 15,
  "points_reward": 100,
  "created_at": "2024-01-15T11:15:00Z"
}
```

**`task_completion`** - Task completion tracking
```json
{
  "id": "completion-404",
  "task_id": "task-303",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "status": "completed",
  "score": 95,
  "completion_time_minutes": 12,
  "completed_at": "2024-01-20T15:30:00Z",
  "created_at": "2024-01-20T15:18:00Z"
}
```

**`scores`** - User scoring system
```json
{
  "id": "score-505",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "activity_id": "activity-202",
  "total_score": 285,
  "level": 3,
  "experience_points": 1500,
  "achievements": ["first_completion", "speed_runner"],
  "created_at": "2024-01-20T15:30:00Z",
  "updated_at": "2024-01-20T15:30:00Z"
}
```

#### 🎯 Vision Board System

**`vision_boards`** - User vision boards
```json
{
  "id": "vision-606",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "title": "My Career Goals 2024",
  "description": "Personal and professional development goals",
  "template_size": "large",
  "background_image": "https://storage.supabase.co/vision-boards/mountain-sunset.jpg",
  "is_public": false,
  "created_at": "2024-01-15T16:00:00Z",
  "updated_at": "2024-01-20T10:00:00Z"
}
```

**`goals`** - Vision board goals
```json
{
  "id": "goal-707",
  "vision_board_id": "vision-606",
  "title": "Become Team Lead",
  "description": "Advance to team leadership position within 6 months",
  "category": "career",
  "priority": "high",
  "target_date": "2024-07-15",
  "position_x": 150,
  "position_y": 200,
  "size": "medium",
  "color": "#4CAF50",
  "progress_percentage": 60,
  "created_at": "2024-01-15T16:15:00Z"
}
```

**`obstacles`** - Goal obstacles
```json
{
  "id": "obstacle-808",
  "goal_id": "goal-707",
  "title": "Limited Leadership Experience",
  "description": "Need more hands-on leadership opportunities",
  "severity": "medium",
  "mitigation_plan": "Volunteer for project leadership roles",
  "position_x": 160,
  "position_y": 220,
  "created_at": "2024-01-15T16:20:00Z"
}
```

#### 💳 Billing System

**`billing_customers`** - Customer billing info
```json
{
  "id": "customer-909",
  "account_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "stripe_customer_id": "cus_1234567890abcdef",
  "email": "billing@acmecorp.com",
  "name": "Acme Corporation",
  "phone": "+1-555-0123",
  "address": {
    "line1": "123 Business St",
    "city": "San Francisco",
    "state": "CA",
    "postal_code": "94105",
    "country": "US"
  },
  "created_at": "2024-01-01T00:00:00Z"
}
```

**`subscriptions`** - Active subscriptions
```json
{
  "id": "sub-1010",
  "billing_customer_id": "customer-909",
  "stripe_subscription_id": "sub_1234567890abcdef",
  "plan_id": "plan-enterprise",
  "status": "active",
  "current_period_start": "2024-01-01T00:00:00Z",
  "current_period_end": "2024-02-01T00:00:00Z",
  "trial_end": null,
  "canceled_at": null,
  "created_at": "2024-01-01T00:00:00Z"
}
```

**`plans`** - Available subscription plans
```json
{
  "id": "plan-enterprise",
  "name": "Enterprise",
  "description": "Full platform access for large organizations",
  "price_monthly": 999.00,
  "price_yearly": 9999.00,
  "features": {
    "max_users": 1000,
    "assessments": "unlimited",
    "activities": "unlimited",
    "support": "priority"
  },
  "is_active": true,
  "created_at": "2024-01-01T00:00:00Z"
}
```

#### 💬 Communication System

**`chats`** - Chat conversations
```json
{
  "id": "chat-1111",
  "account_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "title": "Project Alpha Discussion",
  "chat_type": "group",
  "participant_count": 5,
  "last_message_at": "2024-01-20T16:00:00Z",
  "created_at": "2024-01-15T14:00:00Z"
}
```

**`chat_messages`** - Individual messages
```json
{
  "id": "message-1212",
  "chat_id": "chat-1111",
  "sender_id": "550e8400-e29b-41d4-a716-446655440000",
  "content": "Great work on the presentation!",
  "message_type": "text",
  "is_edited": false,
  "created_at": "2024-01-20T16:00:00Z"
}
```

**`notifications`** - System notifications
```json
{
  "id": "notification-1313",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "title": "New Assessment Available",
  "message": "Leadership Competency Assessment is now available",
  "type": "assessment",
  "channel": "in_app",
  "is_read": false,
  "expires_at": "2024-02-01T00:00:00Z",
  "created_at": "2024-01-20T17:00:00Z"
}
```

#### 🔐 Security & Management

**`invitations`** - User invitations
```json
{
  "id": "invite-1414",
  "email": "newuser@acmecorp.com",
  "account_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "role_id": "role-employee-456",
  "token": "inv_abc123def456",
  "status": "pending",
  "expires_at": "2024-02-01T00:00:00Z",
  "invited_by": "550e8400-e29b-41d4-a716-446655440000",
  "created_at": "2024-01-20T18:00:00Z"
}
```

**`nonces`** - Security tokens
```json
{
  "id": "nonce-1515",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "nonce": "nonce_xyz789abc123",
  "purpose": "email_verification",
  "expires_at": "2024-01-21T18:00:00Z",
  "used_at": null,
  "created_at": "2024-01-20T18:00:00Z"
}
```

**`credits_usage`** - Usage tracking
```json
{
  "id": "usage-1616",
  "account_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "feature": "ai_assessments",
  "credits_used": 50,
  "usage_date": "2024-01-20",
  "description": "Leadership assessment analysis",
  "created_at": "2024-01-20T19:00:00Z"
}
```

---

## Database Relationships Summary

### Core Entity Relationships
```
auth.users → profiles ↔ accounts_memberships ↔ accounts
                ↓                                ↓
          evaluations                    billing_customers
                ↓                                ↓
        vision_boards                    subscriptions
                ↓                                ↓
          activities                         orders
                ↓                                ↓
        chats → chat_messages              notifications
                ↓
        roles → role_permissions
```

### Key Foreign Key Mappings
- `profiles.id` → `auth.users.id`
- `accounts_memberships.account_id` → `accounts.id`
- `accounts_memberships.user_id` → `profiles.id`
- `evaluations.assessment_id` → `assessments.id`
- `evaluations.user_id` → `profiles.id`
- `activities.account_id` → `accounts.id`
- `vision_boards.user_id` → `profiles.id`
- `billing_customers.account_id` → `accounts.id`

---

## Data Patterns & Best Practices

### JSON Storage Usage
- **Metadata**: Flexible assessment configurations
- **Public Data**: Account information and preferences
- **Achievements**: User accomplishment tracking
- **Features**: Plan capabilities and limitations

### Temporal Data Management
- **created_at**: Standard timestamp for all entities
- **updated_at**: Track modifications (where applicable)
- **expires_at**: For time-limited entities (invitations, nonces)
- **completed_at**: For task/assessment completion tracking

### Enum Types
- **user_role**: employee, manager, admin, owner
- **employment_status**: full_time, part_time, contractor
- **assessment_status**: draft, active, archived
- **task_status**: pending, in_progress, completed, failed
- **subscription_status**: active, canceled, past_due, trialing

---

## Integration Recommendations

### API Endpoints Structure
```
/api/v1/accounts/{account_id}/members
/api/v1/assessments/{assessment_id}/evaluations
/api/v1/activities/{activity_id}/tasks
/api/v1/vision-boards/{board_id}/goals
/api/v1/billing/customers/{customer_id}/subscriptions
```

### Real-time Features
- Chat message notifications
- Assessment completion alerts
- Task status updates
- Vision board collaboration

### Analytics Opportunities
- User engagement metrics
- Assessment performance trends
- Billing and subscription analytics
- Learning path effectiveness

---

*This updated analysis provides comprehensive example data structures for the mtzwzsxblhulourliqvr Supabase project. Each table includes realistic sample data that demonstrates the schema relationships and data patterns used in the system.* 