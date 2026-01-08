#!/usr/bin/env python3
"""
Web server with proper COOP/COEP headers for Flutter CanvasKit.

This server adds the required Cross-Origin headers for SharedArrayBuffer
support which is needed by Flutter's CanvasKit renderer in release mode.

Usage:
    1. Build the web app: flutter build web --release
    2. Run this server: python3 serve_web.py
    3. Open: http://localhost:8080

To clear stale ServiceWorker cache:
    - Hard reload: Ctrl+Shift+R (or Cmd+Shift+R on Mac)
    - Or: DevTools > Application > Service Workers > Unregister
"""

import http.server
import socketserver
import os

PORT = 8080
DIRECTORY = "build/web"

class COOPCOEPHandler(http.server.SimpleHTTPRequestHandler):
    """HTTP handler with Cross-Origin headers for CanvasKit."""
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)
    
    def end_headers(self):
        # Required headers for SharedArrayBuffer (CanvasKit)
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        self.send_header('Cross-Origin-Embedder-Policy', 'require-corp')
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        super().end_headers()

if __name__ == "__main__":
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    
    if not os.path.exists(DIRECTORY):
        print(f"Error: {DIRECTORY} not found!")
        print("Run 'flutter build web --release' first.")
        exit(1)
    
    with socketserver.TCPServer(("", PORT), COOPCOEPHandler) as httpd:
        print(f"🌐 Serving Flutter web app at http://localhost:{PORT}")
        print(f"📁 Directory: {DIRECTORY}")
        print("🔒 COOP/COEP headers enabled for CanvasKit")
        print("\n💡 Tip: Hard reload (Ctrl+Shift+R) to clear ServiceWorker cache")
        print("Press Ctrl+C to stop\n")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n👋 Server stopped")
