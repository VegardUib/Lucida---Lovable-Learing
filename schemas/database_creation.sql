-- Denne er implementer på Supabase
-- 16.04.2023

-- Drop tables if they exist
DROP TABLE IF EXISTS tag_references CASCADE;
DROP TABLE IF EXISTS components CASCADE;
DROP TABLE IF EXISTS tags CASCADE;
DROP TABLE IF EXISTS context_roles CASCADE;
DROP TABLE IF EXISTS documents CASCADE;
DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS tenants CASCADE;
DROP TYPE IF EXISTS reference_type CASCADE;
DROP TYPE IF EXISTS tag_type CASCADE;
DROP TYPE IF EXISTS content_type CASCADE;
DROP TYPE IF EXISTS default_view_type CASCADE;
DROP TYPE IF EXISTS role_type CASCADE;
DROP TYPE IF EXISTS hierarchy_type CASCADE;

-- Create ENUM types
CREATE TYPE hierarchy_type AS ENUM ('root', 'branch', 'leaf');
CREATE TYPE role_type AS ENUM ('owner', 'editor', 'viewer');
CREATE TYPE default_view_type AS ENUM ('grid', 'list');
CREATE TYPE content_type AS ENUM ('text', 'image', 'video');
CREATE TYPE tag_type AS ENUM ('category', 'label');
CREATE TYPE reference_type AS ENUM ('component', 'document');

-- Table definitions
CREATE TABLE tenants (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE projects (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  hierarchy_type hierarchy_type NOT NULL,
  public BOOLEAN NOT NULL,
  tenant_id INTEGER REFERENCES tenants(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE documents (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  hierarchy_type hierarchy_type NOT NULL,
  public BOOLEAN NOT NULL,
  project_id UUID REFERENCES projects(id),
  default_view_type default_view_type NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE context_roles (
  id SERIAL PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  role_type role_type NOT NULL,
  document_id UUID REFERENCES documents(id),
  project_id UUID REFERENCES projects(id),
  tenant_id INTEGER REFERENCES tenants(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE tags (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  tag_type tag_type NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE components (
  id UUID PRIMARY KEY,
  content_type content_type NOT NULL,
  content TEXT NOT NULL,
  meta_data JSONB,
  document_id UUID REFERENCES documents(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE tag_references (
  id SERIAL PRIMARY KEY,
  reference_type reference_type NOT NULL,
  reference TEXT NOT NULL,
  tag_id INTEGER REFERENCES tags(id),
  entity_id UUID NOT NULL, -- depending on reference_type, it can reference either documents(id) or components(id)
  UNIQUE (reference_type, reference, entity_id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Create update_updated_at_column function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers to update the updated_at column
CREATE TRIGGER update_tenants_updated_at
BEFORE UPDATE ON tenants
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_projects_updated_at
BEFORE UPDATE ON projects
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_documents_updated_at
BEFORE UPDATE ON documents
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_context_roles_updated_at
BEFORE UPDATE ON context_roles
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tags_updated_at
BEFORE UPDATE ON tags
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_components_updated_at
BEFORE UPDATE ON components
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tag_references_updated_at
BEFORE UPDATE ON tag_references
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();