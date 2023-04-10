-- I tillegg må Supabase settes opp med OAuth.
-- Create tenants table
CREATE TABLE tenants (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

-- Create projects table
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    hierarchy_type ENUM('parent', 'child') NOT NULL,
    public BOOLEAN NOT NULL DEFAULT false,
    tenant_id INTEGER NOT NULL REFERENCES tenants(id)
);

-- Create users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    role ENUM('admin', 'member') NOT NULL DEFAULT 'member'
);

-- Create documents table
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    hierarchy_type ENUM('parent', 'child') NOT NULL,
    public BOOLEAN NOT NULL DEFAULT false,
    project_id UUID NOT NULL REFERENCES projects(id),
    default_view_type ENUM('BITS', 'JATS') NOT NULL DEFAULT 'BITS'
);

-- Create tags table
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    tag_type ENUM('author', 'subject') NOT NULL DEFAULT 'author'
);

-- Create components table
CREATE TABLE components (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content TEXT NOT NULL,
    content_type ENUM('text', 'image', 'video', 'audio') NOT NULL DEFAULT 'text',
    meta_data JSONB,
    document_id UUID NOT NULL REFERENCES documents(id)
);

-- Create tag references table
CREATE TABLE tag_references (
    id SERIAL PRIMARY KEY,
    reference_type ENUM('tag', 'component') NOT NULL,
    reference TEXT NOT NULL,
    tag_id INTEGER NOT NULL REFERENCES tags(id),
    component_id UUID NOT NULL REFERENCES components(id)
);

-- Create roles table
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT
);

-- Create organization table
CREATE TABLE organizations (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

-- Create users_organizations table
CREATE TABLE users_organizations (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    organization_id INTEGER NOT NULL REFERENCES organizations(id),
    role_id INTEGER NOT NULL REFERENCES roles(id)
);

-- Create users_projects table
CREATE TABLE users_projects (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    project_id UUID NOT NULL REFERENCES projects(id),
    role_id INTEGER NOT NULL REFERENCES roles(id)
);

-- Create users_documents table
CREATE TABLE users_documents (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    document_id UUID NOT NULL REFERENCES documents(id),
    role_id INTEGER NOT NULL REFERENCES roles(id)
);

-- Create API keys table
CREATE TABLE api_keys (
    id SERIAL PRIMARY KEY,
    key TEXT NOT NULL UNIQUE,
    user_id INTEGER NOT NULL REFERENCES users(id),
    organization_id INTEGER NOT NULL REFERENCES organizations(id),
    project_id UUID NOT NULL REFERENCES projects(id),
    document_id UUID NOT NULL REFERENCES documents(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    revoked BOOLEAN NOT NULL DEFAULT false
);

-- Create policies for RLS
CREATE POLICY select_project_policy ON projects FOR SELECT USING (EXISTS (
    SELECT FROM users_projects up
    WHERE up.user_id = current_setting('jwt.claims.sub')::INTEGER
    AND up.project_id = projects.id
));

CREATE POLICY insert_project_policy ON projects FOR INSERT WITH CHECK (EXISTS (
    SELECT FROM users_organizations uo
    JOIN users_projects up ON uo.organization_id = up.organization_id
    WHERE uo.user_id = current_setting
-- Create tenants table
CREATE TABLE tenants (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

-- Create projects table
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    hierarchy_type ENUM('parent', 'child') NOT NULL,
    public BOOLEAN NOT NULL DEFAULT false,
    tenant_id INTEGER NOT NULL REFERENCES tenants(id)
);

-- Create users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    role ENUM('admin', 'member') NOT NULL DEFAULT 'member'
);

-- Create documents table
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    hierarchy_type ENUM('parent', 'child') NOT NULL,
    public BOOLEAN NOT NULL DEFAULT false,
    project_id UUID NOT NULL REFERENCES projects(id),
    default_view_type ENUM('BITS', 'JATS') NOT NULL DEFAULT 'BITS'
);

-- Create tags table
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    tag_type ENUM('author', 'subject') NOT NULL DEFAULT 'author'
);

-- Create components table
CREATE TABLE components (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content TEXT NOT NULL,
    content_type ENUM('text', 'image', 'video', 'audio') NOT NULL DEFAULT 'text',
    meta_data JSONB,
    document_id UUID NOT NULL REFERENCES documents(id)
);

-- Create tag references table
CREATE TABLE tag_references (
    id SERIAL PRIMARY KEY,
    reference_type ENUM('tag', 'component') NOT NULL,
    reference TEXT NOT NULL,
    tag_id INTEGER NOT NULL REFERENCES tags(id),
    component_id UUID NOT NULL REFERENCES components(id)
);

-- Create roles table
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT
);

-- Create organization table
CREATE TABLE organizations (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

-- Create users_organizations table
CREATE TABLE users_organizations (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    organization_id INTEGER NOT NULL REFERENCES organizations(id),
    role_id INTEGER NOT NULL REFERENCES roles(id)
);

-- Create users_projects table
CREATE TABLE users_projects (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    project_id UUID NOT NULL REFERENCES projects(id),
    role_id INTEGER NOT NULL REFERENCES roles(id)
);

-- Create users_documents table
CREATE TABLE users_documents (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    document_id UUID NOT NULL REFERENCES documents(id),
    role_id INTEGER NOT NULL REFERENCES roles(id)
);

-- Create API keys table
CREATE TABLE api_keys (
    id SERIAL PRIMARY KEY,
    key TEXT NOT NULL UNIQUE,
    user_id INTEGER NOT NULL REFERENCES users(id),
    organization_id INTEGER NOT NULL REFERENCES organizations(id),
    project_id UUID NOT NULL REFERENCES projects(id),
    document_id UUID NOT NULL REFERENCES documents(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    revoked BOOLEAN NOT NULL DEFAULT false
);

-- Create policies for RLS
CREATE POLICY select_project_policy ON projects FOR SELECT USING (EXISTS (
    SELECT FROM users_projects up
    WHERE up.user_id = current_setting('jwt.claims.sub')::INTEGER
    AND up.project_id = projects.id
));

CREATE POLICY insert_project_policy ON projects FOR INSERT WITH CHECK (EXISTS (
    SELECT FROM users_organizations uo
    JOIN users_projects up ON uo.organization_id = up.organization_id
    WHERE uo.user_id = current_setting
