"use client";

import { useState, useEffect } from "react";
import Link from "next/link";

export default function LoginPage() {
    const [showPassword, setShowPassword] = useState(false);
    const [isDark, setIsDark] = useState(false);

    useEffect(() => {
        // Check local storage or preference
        const checkTheme = () => {
            if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                setIsDark(true);
                document.documentElement.classList.add('dark');
            } else {
                setIsDark(false);
                document.documentElement.classList.remove('dark');
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
        <div className="min-h-screen grid place-items-center relative overflow-hidden transition-colors duration-500 font-sans">
            {/* Background Elements */}
            <div className="fixed inset-0 pointer-events-none overflow-hidden">
                {/* Top Right Red Blob */}
                <div className="shape-blob bg-primary/30 w-96 h-96 rounded-full -top-20 -right-20 animate-float"></div>
                {/* Bottom Left Blue Blob */}
                <div className="shape-blob bg-blue-500/20 w-80 h-80 rounded-full top-1/2 -left-20 animate-float-delayed"></div>
                {/* Center Subtle */}
                <div className="shape-blob bg-purple-500/20 w-[600px] h-[600px] rounded-full -bottom-40 right-1/2 translate-x-1/2 hidden md:block"></div>

                {/* Grid Pattern Overlay */}
                <div className="absolute inset-0 bg-[url('https://grainy-gradients.vercel.app/noise.svg')] opacity-20 brightness-100 contrast-150 mix-blend-overlay"></div>
            </div>

            {/* Theme Toggle Switch */}
            <button
                onClick={toggleTheme}
                className="absolute top-6 right-6 z-50 p-3 rounded-full glass-panel shadow-lg hover:scale-110 active:scale-95 transition-all group"
            >
                {isDark ? (
                    <span className="material-icons-round text-slate-200 group-hover:-rotate-12 transition-transform block">dark_mode</span>
                ) : (
                    <span className="material-icons-round text-slate-600 group-hover:rotate-12 transition-transform block">light_mode</span>
                )}
            </button>

            {/* Login Card */}
            <main className="w-full max-w-md p-6 relative z-10 perspective-1000">

                <div className="glass-panel rounded-[2.5rem] p-8 md:p-10 shadow-2xl relative overflow-hidden group">

                    {/* Decorative Top Line */}
                    <div className="absolute top-0 left-0 w-full h-1.5 bg-gradient-to-r from-primary via-orange-400 to-primary"></div>

                    {/* Logo Section */}
                    <div className="flex flex-col items-center mb-8">
                        <div className="relative mb-4">
                            <div className="absolute inset-0 bg-primary/20 rounded-2xl blur-xl animate-pulse-slow"></div>
                            <div className="w-16 h-16 bg-gradient-to-br from-primary to-primary-dark rounded-2xl flex items-center justify-center shadow-lg shadow-primary/30 relative z-10 transform group-hover:rotate-3 transition-transform duration-500">
                                <span className="material-icons-round text-white text-3xl">analytics</span>
                            </div>
                        </div>
                        <h1 className="text-2xl font-extrabold tracking-tight">Welcome Back</h1>
                        <p className="text-slate-500 text-sm font-medium mt-1">Sign in to TireGuard AI</p>
                    </div>

                    {/* Form */}
                    <form className="space-y-5" onSubmit={(e) => { e.preventDefault(); console.log('Login submitted'); }}>

                        {/* Email Input */}
                        <div className="space-y-1.5">
                            <label className="text-xs font-bold text-slate-500 uppercase tracking-wider ml-1">Email Address</label>
                            <div className="relative group">
                                <span className="material-icons-round absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-primary transition-colors z-10">alternate_email</span>
                                <input type="email"
                                    className="w-full pl-11 pr-4 py-3.5 rounded-xl glass-input text-sm font-semibold placeholder:text-slate-400"
                                    placeholder="name@example.com"
                                    defaultValue="demo@tireguard.ai"
                                />
                            </div>
                        </div>

                        {/* Password Input */}
                        <div className="space-y-1.5">
                            <label className="text-xs font-bold text-slate-500 uppercase tracking-wider ml-1">Password</label>
                            <div className="relative group">
                                <span className="material-icons-round absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-primary transition-colors z-10">lock</span>
                                <input
                                    type={showPassword ? "text" : "password"}
                                    className="w-full pl-11 pr-12 py-3.5 rounded-xl glass-input text-sm font-semibold placeholder:text-slate-400"
                                    placeholder="••••••••"
                                />
                                <button
                                    type="button"
                                    onClick={() => setShowPassword(!showPassword)}
                                    className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 transition-colors"
                                >
                                    <span className="material-icons-round text-lg">
                                        {showPassword ? 'visibility_off' : 'visibility'}
                                    </span>
                                </button>
                            </div>
                        </div>

                        {/* Remember & Forgot */}
                        <div className="flex items-center justify-between text-xs font-semibold">
                            <label className="flex items-center gap-2 cursor-pointer text-slate-600 dark:text-slate-400 hover:text-primary transition-colors">
                                <div className="relative flex items-center">
                                    <input type="checkbox" className="peer sr-only" />
                                    <div className="w-4 h-4 border-2 border-slate-300 dark:border-slate-600 rounded peer-checked:bg-primary peer-checked:border-primary transition-all"></div>
                                    <span className="material-icons-round text-[10px] text-white absolute inset-0 opacity-0 peer-checked:opacity-100 pointer-events-none flex items-center justify-center">check</span>
                                </div>
                                Remember me
                            </label>
                            <Link href="#" className="text-primary hover:text-primary-dark underline decoration-2 decoration-transparent hover:decoration-primary/30 transition-all">
                                Forgot password?
                            </Link>
                        </div>

                        {/* Submit Button */}
                        <button type="submit" className="w-full py-4 rounded-xl bg-gradient-to-r from-primary to-orange-500 text-white font-bold tracking-wide shadow-lg shadow-primary/30 hover:shadow-primary/50 hover:scale-[1.02] active:scale-[0.98] transition-all duration-300 flex items-center justify-center gap-2 group/btn">
                            <span>Sign In</span>
                            <span className="material-icons-round group-hover/btn:translate-x-1 transition-transform">arrow_forward</span>
                        </button>

                    </form>

                    <div className="mt-8 text-center">
                        <p className="text-sm font-semibold text-slate-500">
                            Don&apos;t have an account?
                            <Link href="#" className="text-primary hover:text-primary-dark font-bold hover:underline ml-1">
                                Create Account
                            </Link>
                        </p>
                    </div>

                    {/* Footer Info */}
                    <div className="mt-8 pt-6 border-t border-slate-200/50 dark:border-slate-700/50 text-center">
                        <p className="text-[10px] text-slate-400 font-bold tracking-widest uppercase">Secured by TireGuard AI</p>
                    </div>

                </div>
            </main>
        </div>
    );
}
