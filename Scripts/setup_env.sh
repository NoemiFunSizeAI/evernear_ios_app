#!/bin/bash

# Check if required API keys are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Please provide your API keys as arguments:"
    echo "./setup_env.sh YOUR_OPENAI_KEY YOUR_LEOPARD_KEY"
    exit 1
fi

# Create or update .env file
cat > .env << EOL
GEMINI_API_KEY=$1
LEOPARD_API_KEY=$2
EOL

# Export the API keys for the current session
export GEMINI_API_KEY=$1
export LEOPARD_API_KEY=$2

# Check audio setup
echo "Checking audio configuration..."

# Check microphone access
if ! system_profiler SPAudioDataType | grep -q "Input"; then
    echo "⚠️  Warning: No microphone detected"
    echo "Please ensure you have a working microphone connected"
fi

# Check audio permissions
if ! swift -e 'import AVFoundation; print(AVAudioSession.sharedInstance().recordPermission.rawValue)' 2>/dev/null; then
    echo "⚠️  Warning: Microphone permissions not granted"
    echo "Please grant microphone access in System Preferences > Security & Privacy > Microphone"
fi

# Setup voice data directory
VOICE_DATA_DIR="${HOME}/Library/Application Support/EverNear/VoiceData"
mkdir -p "$VOICE_DATA_DIR"
chmod 700 "$VOICE_DATA_DIR"

echo "Environment setup complete!"
echo "✓ API keys saved to .env and exported"
echo "✓ Voice data directory created at $VOICE_DATA_DIR"
echo "✓ Audio configuration checked"
echo ""
echo "To test the AI integration: swift Scripts/test_ai.swift"
echo "To test voice features: swift Scripts/test_voice.swift"
