#!/usr/bin/env python3
"""
Audio File Optimization Script
This script helps optimize audio files to reduce APK size.
"""

import os
import subprocess
from pathlib import Path

def get_audio_files():
    """Get all audio files in the assets directory."""
    audio_dir = Path("assets/audio/386_Music")
    audio_files = list(audio_dir.glob("*.mp3"))
    return audio_files

def get_file_size(file_path):
    """Get file size in MB."""
    return os.path.getsize(file_path) / (1024 * 1024)

def analyze_audio_files():
    """Analyze current audio files."""
    audio_files = get_audio_files()
    total_size = 0
    
    print("📊 Current Audio Files Analysis:")
    print("=" * 50)
    
    for file in audio_files:
        size_mb = get_file_size(file)
        total_size += size_mb
        print(f"📁 {file.name}: {size_mb:.1f}MB")
    
    print("=" * 50)
    print(f"📏 Total Audio Size: {total_size:.1f}MB")
    print(f"🎯 Target Size: ~30MB (75% reduction)")
    
    return audio_files, total_size

def suggest_optimizations():
    """Suggest optimization strategies."""
    print("\n🎯 Optimization Strategies:")
    print("1. Compress MP3 files to 128kbps (saves ~60%)")
    print("2. Create 30-second preview versions (saves ~80%)")
    print("3. Keep only 5-10 essential tracks")
    print("4. Use OGG format for better compression")
    
    print("\n🛠️ Manual Steps:")
    print("1. Use FFmpeg: ffmpeg -i input.mp3 -b:a 128k output.mp3")
    print("2. Use online tools: Audacity, Online Audio Converter")
    print("3. Select only essential tracks for the app")

if __name__ == "__main__":
    audio_files, total_size = analyze_audio_files()
    suggest_optimizations()







