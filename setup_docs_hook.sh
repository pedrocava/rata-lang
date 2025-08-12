#!/bin/bash
# Setup script for documentation git hooks

echo "Setting up Rata documentation git hooks..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Create hooks directory if it doesn't exist
if [ ! -d ".git/hooks" ]; then
    mkdir -p .git/hooks
fi

# Copy our hook to the git hooks directory
if [ -f "hooks/post-commit" ]; then
    cp hooks/post-commit .git/hooks/post-commit
    chmod +x .git/hooks/post-commit
    echo "✅ Post-commit hook installed"
else
    echo "❌ hooks/post-commit not found"
    exit 1
fi

echo "🎉 Documentation hooks setup complete!"
echo ""
echo "The hook will automatically regenerate Markdown documentation when you commit changes to:"
echo "  - rata_parser/lib/rata_modules/*.ex"
echo "  - specs/samples/*.rata" 
echo "  - any *.rata files"
echo ""
echo "To manually regenerate documentation, use:"
echo "  cd rata_parser && elixir -e 'RataDocs.build_all()'"