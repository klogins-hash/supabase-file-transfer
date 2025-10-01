-- Create the file_transfers table in Supabase
-- Run this SQL in your Supabase SQL Editor

CREATE TABLE IF NOT EXISTS file_transfers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    original_name TEXT NOT NULL,
    s3_key TEXT NOT NULL UNIQUE,
    s3_url TEXT NOT NULL,
    file_size BIGINT DEFAULT 0,
    mime_type TEXT,
    status TEXT DEFAULT 'uploaded' CHECK (status IN ('uploaded', 'processing', 'failed')),
    parent_zip TEXT, -- For files extracted from ZIP archives
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_file_transfers_created_at ON file_transfers(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_file_transfers_status ON file_transfers(status);
CREATE INDEX IF NOT EXISTS idx_file_transfers_parent_zip ON file_transfers(parent_zip) WHERE parent_zip IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_file_transfers_mime_type ON file_transfers(mime_type);

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_file_transfers_updated_at 
    BEFORE UPDATE ON file_transfers 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (RLS) if needed
-- ALTER TABLE file_transfers ENABLE ROW LEVEL SECURITY;

-- Create a policy for authenticated users (optional)
-- CREATE POLICY "Users can manage their own files" ON file_transfers
--     FOR ALL USING (auth.uid() IS NOT NULL);

-- Grant permissions to authenticated users
-- GRANT ALL ON file_transfers TO authenticated;
-- GRANT ALL ON file_transfers TO anon; -- Only if you want anonymous access

COMMENT ON TABLE file_transfers IS 'Stores metadata for files uploaded to S3 via the file transfer application';
COMMENT ON COLUMN file_transfers.s3_key IS 'Unique S3 object key for the uploaded file';
COMMENT ON COLUMN file_transfers.parent_zip IS 'Original ZIP filename if this file was extracted from an archive';
COMMENT ON COLUMN file_transfers.metadata IS 'Additional file metadata stored as JSON';