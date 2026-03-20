"use client";

import Navbar from "@/components/Navbar";
import { useState, useEffect } from "react";

export default function SettingsPage() {
    const [isDark, setIsDark] = useState(false);

    useEffect(() => {
        // Check local storage or preference
        const checkTheme = () => {
            if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                setIsDark(true);
            } else {
                setIsDark(false);
            }
        };
        checkTheme();
    }, []);

    const toggleTheme = () => {
        if (isDark) {
            document.documentElement.classList.remove('dark');
            localStorage.theme = 'light';
            setIsDark(false);
        } else {
            document.documentElement.classList.add('dark');
            localStorage.theme = 'dark';
            setIsDark(true);
        }
    };

    return (
        <div className="bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-100 font-sans min-h-screen">
            <div className="max-w-md mx-auto min-h-screen relative flex flex-col shadow-2xl bg-background-light dark:bg-background-dark overflow-hidden">

                {/* Header Section */}
                <header className="sticky top-0 z-40 glass-panel px-6 py-4 flex flex-col gap-4">
                    <div className="flex justify-between items-center">
                        <div className="flex items-center gap-3">
                            <div className="w-10 h-10 bg-slate-200 dark:bg-slate-800 rounded-xl flex items-center justify-center shadow-lg">
                                <span className="material-icons-round text-slate-500">settings</span>
                            </div>
                            <div>
                                <h1 className="font-extrabold text-lg leading-tight tracking-tight">Settings</h1>
                                <p className="text-[10px] text-slate-500 font-bold uppercase tracking-[0.2em]">App Configuration</p>
                            </div>
                        </div>
                    </div>
                </header>

                {/* Main Content */}
                <main className="flex-1 relative pb-32 no-scrollbar overflow-y-auto px-6 pt-6">

                    <div className="space-y-6">

                        {/* Profile Card */}
                        <div className="glass-panel p-5 rounded-[2rem] flex items-center gap-4">
                            <div className="w-16 h-16 rounded-full bg-gradient-to-br from-primary to-purple-500 flex items-center justify-center text-white text-xl font-bold shadow-lg shadow-purple-500/30">
                                JD
                            </div>
                            <div>
                                <h3 className="font-bold text-lg">John Doe</h3>
                                <p className="text-xs text-slate-500">Premium Member</p>
                            </div>
                            <button className="ml-auto text-primary text-sm font-bold">EDIT</button>
                        </div>

                        {/* Appearance Section */}
                        <div>
                            <h4 className="text-xs font-bold text-slate-500 uppercase tracking-widest mb-3 ml-2">Appearance</h4>
                            <div className="glass-panel p-1 rounded-2xl">
                                <div className="flex items-center justify-between p-4 border-b border-slate-100 dark:border-slate-800 last:border-0 hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors rounded-xl cursor-pointer" onClick={toggleTheme}>
                                    <div className="flex items-center gap-3">
                                        <span className="material-icons-round text-slate-400">dark_mode</span>
                                        <span className="font-semibold text-sm">Dark Mode</span>
                                    </div>
                                    <div className={`w-12 h-6 rounded-full p-1 transition-colors ${isDark ? 'bg-primary' : 'bg-slate-200'}`}>
                                        <div className={`w-4 h-4 rounded-full bg-white shadow-sm transition-transform ${isDark ? 'translate-x-6' : 'translate-x-0'}`}></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* Privacy Section */}
                        <div>
                            <h4 className="text-xs font-bold text-slate-500 uppercase tracking-widest mb-3 ml-2">Privacy Policy</h4>
                            <button className="w-full glass-panel p-4 rounded-2xl flex items-center justify-between hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors text-danger">
                                <div className="flex items-center gap-3">
                                    <span className="material-icons-round">policy</span>
                                    <span className="font-semibold text-sm">Privacy Policy</span>
                                </div>
                            </button>
                        </div>

                        {/* General Section */}
                        <div>
                            <h4 className="text-xs font-bold text-slate-500 uppercase tracking-widest mb-3 ml-2">General</h4>
                            <button className="w-full glass-panel p-4 rounded-2xl flex items-center justify-between mb-3 hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors">
                                <div className="flex items-center gap-3">
                                    <span className="material-icons-round text-slate-400">language</span>
                                    <span className="font-semibold text-sm">Language</span>
                                </div>
                                <span className="text-xs font-bold text-slate-400">English</span>
                            </button>
                            <button className="w-full glass-panel p-4 rounded-2xl flex items-center justify-between hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors text-danger">
                                <div className="flex items-center gap-3">
                                    <span className="material-icons-round">logout</span>
                                    <span className="font-semibold text-sm">Log Out</span>
                                </div>
                            </button>
                        </div>

                    </div>

                </main>

                <Navbar />
            </div>
        </div>
    );
}
