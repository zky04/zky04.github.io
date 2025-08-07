#!/usr/bin/env python3
"""
Content Synchronization Script
Helps keep README.md in sync with homepage content
"""

import yaml
import re
from pathlib import Path

def load_personal_data():
    """Load personal information from _data/personal.yml"""
    with open('_data/personal.yml', 'r', encoding='utf-8') as f:
        return yaml.safe_load(f)

def update_readme_with_data(data):
    """Update README.md using personal data"""
    readme_path = Path('README.md')
    
    # Read current README
    with open(readme_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Update sections (basic example)
    # You can extend this to update specific sections
    print("📝 README sync suggestions:")
    print(f"- Name: {data['name']}")
    print(f"- Bio: {data['bio_short']}")
    print(f"- Email: {data['contact']['email']}")
    print(f"- Research interests: {len(data['research_interests'])} items")
    
    print("\n✅ Manual review recommended for:")
    print("- Publications section")
    print("- Recent news/updates")
    print("- Contact information changes")

if __name__ == "__main__":
    try:
        data = load_personal_data()
        update_readme_with_data(data)
        print("\n🔄 Sync check completed!")
    except Exception as e:
        print(f"❌ Error: {e}")