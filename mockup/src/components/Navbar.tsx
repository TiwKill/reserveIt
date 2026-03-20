"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useRef } from "react";

export default function Navbar() {
    const pathname = usePathname();
    const router = useRouter();
    const fileInputRef = useRef<HTMLInputElement>(null);

    // Helper to determine if a route is active
    const isActive = (path: string) => pathname === path;

    return (
        <nav className="fixed bottom-0 w-full max-w-md glass-panel border-t border-white/20 dark:border-white/5 px-12 pt-2 pb-6 flex justify-between items-center rounded-t-[32px] shadow-[0_-10px_40px_rgba(0,0,0,0.1)] z-50 left-1/2 -translate-x-1/2">

            {/* Left: Timeline */}
            <Link href="/timeline" className={`relative flex flex-col items-center gap-1 transition-all active:scale-90 ${isActive('/timeline') ? 'text-primary' : 'text-slate-400 hover:text-slate-600 dark:hover:text-slate-300'}`}>
                <span className="material-icons-round text-[28px]">route</span>
                <span className="text-[10px] font-bold tracking-wide">Timeline</span>
                {isActive('/timeline') && (
                    <span className="absolute -bottom-2 w-1 h-1 bg-primary rounded-full shadow-[0_0_8px_rgba(239,68,68,0.8)]"></span>
                )}
            </Link>

            {/* Center: Camera FAB */}
            <div className="relative -top-8">
                <input 
                    type="file" 
                    accept="image/*" 
                    capture="environment"
                    className="hidden" 
                    ref={fileInputRef}
                    onChange={(e) => {
                        if (e.target.files && e.target.files.length > 0) {
                             // Mockup: Redirect to scan page to show analysis "finding"
                             // In a real app we would pass the file content
                             router.push('/scan');
                        }
                    }}
                />
                <button 
                    onClick={() => fileInputRef.current?.click()}
                    className="w-[64px] h-[64px] bg-primary rounded-full flex items-center justify-center shadow-[0_8px_24px_rgba(239,68,68,0.4)] transform transition-all duration-300 hover:scale-110 active:scale-95 group border-[6px] border-background-light dark:border-background-dark text-white overflow-hidden"
                >
                    <div className="absolute inset-0 bg-gradient-to-tr from-white/0 via-white/10 to-white/30 opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                    <span className="material-icons-round text-3xl relative z-10 drop-shadow-sm">photo_camera</span>
                </button>
            </div>

            {/* Right: Garage */}
            <Link href="/garage" className={`relative flex flex-col items-center gap-1 transition-all active:scale-90 ${isActive('/garage') ? 'text-primary' : 'text-slate-400 hover:text-slate-600 dark:hover:text-slate-300'}`}>
                <span className="material-icons-round text-[28px]">garage</span>
                <span className="text-[10px] font-bold tracking-wide">Garage</span>
                {isActive('/garage') && (
                    <span className="absolute -bottom-2 w-1 h-1 bg-primary rounded-full shadow-[0_0_8px_rgba(239,68,68,0.8)]"></span>
                )}
            </Link>
        </nav>
    );
}
