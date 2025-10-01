#!/bin/bash

echo "🚀 Setting up Supabase File Transfer App"
echo "======================================="

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js version 18+ required. Current version: $(node --version)"
    exit 1
fi

echo "✅ Node.js $(node --version) detected"

# Install root dependencies
echo "📦 Installing server dependencies..."
npm install

# Install client dependencies
echo "📦 Installing client dependencies..."
cd client && npm install && cd ..

# Build client
echo "🏗️  Building React client..."
npm run build:client

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚠️  Creating .env file from template..."
    cp .env.example .env
    echo "📝 Please edit .env file with your configuration:"
    echo "   - AWS S3 credentials and bucket name"
    echo "   - Supabase URL and API key"
    echo ""
fi

# Check if Docker is installed
if command -v docker &> /dev/null; then
    echo "🐳 Docker detected - you can build with: docker build -t supabase-file-transfer ."
else
    echo "⚠️  Docker not found - install Docker for containerized deployment"
fi

# Check if Railway CLI is installed
if command -v railway &> /dev/null; then
    echo "🚄 Railway CLI detected - you can deploy with: railway up"
else
    echo "💡 Install Railway CLI for easy deployment: npm install -g @railway/cli"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env file with your credentials"
echo "2. Run the SQL schema in your Supabase project (see supabase-schema.sql)"
echo "3. Start development server: npm run dev"
echo "4. Or build Docker image: docker build -t supabase-file-transfer ."
echo "5. Deploy to Railway: railway up"
echo ""
echo "🌐 The app will be available at http://localhost:3000"