# Supabase File Transfer App

A Docker-hosted web application for transferring files to Supabase using S3 storage. Built with React, Node.js, Express, and designed for easy deployment on Railway.

## Features

- 🚀 **Multiple Upload Modes**: Single file, multiple files, or ZIP extraction
- 📁 **ZIP File Support**: Automatically extract and upload ZIP contents
- 🗄️ **Supabase Integration**: Store file metadata in Supabase database
- ☁️ **S3 Storage**: Secure file storage on AWS S3
- 🐳 **Docker Ready**: Containerized for easy deployment
- 🚄 **Railway Optimized**: Pre-configured for Railway deployment
- 🎨 **Modern UI**: Clean, responsive interface with Tailwind CSS
- 📊 #�+File Management**: View, download, and delete uploaded files

## Architecture

```
┌───────────┐────┌────────────┐────┌────────────┐────┌────────────┐
│   React     │    │   Express   │    │   AWS S3    │    │  Supabase   │
│   Frontend  │─┸│   Backend   │───┸│   Storage    │    │   Database   │
│            │     │             │     │             │     │             │
└───────────┘────└────────────┘────└────────────┘────└────────────┘
```

## Quick Start

### 1. Prerequisites

- Node.js 18+
- Docker (for containerized deployment)
- AWS S3 bucket
- Supabase project

### 2. Setup Supabase Database

Run the SQL sthema in your Supabase SQL Editor:

```sql
-- See supabase-schema.sql for the complete schema
CREATE TABLE file_transfers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    original_name TEXT NOT NULL,
    s3_key TEXT NOT NULL UNIQUE,
    s3_url TEXT NOT NULL,
    file_size BIGINT DEFAULT 0,    mime_type TEXT,
    status TEXT DEFAULT 'uploaded',
    parent_zip TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 3. Environment Configuration

Copy `.env.example` to `.env` and configure:

```bash
# Server Configuration
PORT=3000
NODE_ENV=production

# AWS S3 Configuration
AWS_ACCESS_KEY_ID=your_aws_access_key_id
AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
AWS_REGION=us-east-1
S3_BUCKET_NAME=your-s3-bucket-name

# Supabase Configuration
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 4. Local Development

```bash
# Install dependencies
npm install
cd client && npm install && cd ..

# Build client
npm run build:client

# Start development server
npm run dev
```

### 5. Docker Deployment

```bash
# Build Docker image
docker build -t supabase-file-transfer .

# Run container
docker run -p 3000:3000 --env-file .env supabase-file-transfer
```

## Railway Deployment

### Option 1: Deploy from GitHub

1. Push your code to GitHub
2. Connect your GitHub repo to Railway
3. Set environment variables in Railway dashboard
4. Deploy automatically

### Option 2: Railway CLI

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login and initialize
railway login
railway init

# Set environment variables
railway variables set AWS_ACCESS_KEY_ID=your_key
railway variables set AWS_SECRET_ACCESS_KEY=your_secret
railway variables set S3_BUCKET_NAME=your_bucket
railway variables set SUPABASE_URL=your_url
railway variables set SUPABASE_ANON_KEY=your_key

# Deploy
railway up
```

## API Endpoints

### File Upload
- `POST /api/upload` - Upload single file
- `POST /api/upload-multiple` - Upload multiple files
- `POST /api/unzip-upload` - Upload and extract ZIP file

### File Management
- `GET /api/files` - List uploaded files
- `DELETE /api/files/:id` - Delete file

### Health Check
- `GET /api/health` - Application health status

## File Upload Modes

### Single File Upload
Upload one file at a time with progress tracking.

### Multiple File Upload
Upload multiple files simultaneously with batch processing.

### ZIP Extraction
Upload a ZIP file and automatically extract all contents, uploading each file individually while maintaining folder structure.

## Security Features

- Rate limiting (100 requests per 15 minutes)
- Helmet.js security headers
- File size limits (100MB per file)
- CORS protection
- Input validation and sanitization

## Monitoring & Health Checks

The application includes:
- Health check endpoint (`/api/health`)
- Docker health checks
- Railway-optimized configuration
- Error handling and logging

## File Storage Structure

Files are stored in S3 with the following structure:
```
your-bucket/
├── uploads/
│   ├── {uuid}/
│   │   └── original-filename.ext
│   └── extracted/
│       ├── {uuid}/
│       │   └── extracted-file.ext
```

## Database Schema

The `file_transfers` table stores:
- File metadata (name, size, type)
- S3 storage information
- Upload status and timestamps
- Parent ZIP reference (for extracted files)

## Troubleshooting

### Common Issues

1. **S3 Upload Errors**: Check AWS credentials and bucket permissions
2. **Supabase Connection**: Verify URL and API key
3. **Docker Build Issues**: Ensure all dependencies are properly installed
4. **Railway Deployment**: Check environment variables are set correctly

### Logs

Check application logs for detailed error information:
```bash
# Docker logs
docker logs container_name

# Railway logs
railway logs
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

MIT License - see LICENSE file for details.

## Support

For issues and questions:
- Create an issue on GitHub
- Check the troubleshooting section
- Review Railway and Supabase documentation

---

**Built with ❤️ for seamless file transfers to Supabase**

