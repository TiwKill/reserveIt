"use client";

import { useState } from "react";
import Navbar from "@/components/Navbar";
import Link from "next/link";
import { motion } from "framer-motion";

export default function TimelinePage() {
    const [activeDetail, setActiveDetail] = useState<string | null>(null);

    const toggleDetail = (id: string) => {
        setActiveDetail(activeDetail === id ? null : id);
    };

    return (
        <div className="bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-100 font-sans min-h-screen">
            <div className="max-w-md mx-auto min-h-screen relative flex flex-col shadow-2xl bg-background-light dark:bg-background-dark overflow-hidden">

                {/* Header Section */}
                <header className="sticky top-0 z-40 glass-panel px-6 py-4 flex flex-col gap-4">
                    <div className="flex justify-between items-center">
                        <div className="flex items-center gap-3">
                            <div className="w-10 h-10 bg-primary rounded-xl flex items-center justify-center shadow-lg shadow-primary/30">
                                <span className="material-icons-round text-white">analytics</span>
                            </div>
                            <div>
                                <h1 className="font-extrabold text-lg leading-tight tracking-tight">TireGuard AI</h1>
                                <p className="text-[10px] text-slate-500 font-bold uppercase tracking-[0.2em]">Diagnostic Dashboard</p>
                            </div>
                        </div>
                        <Link href="/settings" className="w-10 h-10 rounded-full flex items-center justify-center hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors">
                            <span className="material-icons-round text-slate-300">chevron_right</span>
                        </Link>
                    </div>

                    {/* Health Summary Card */}
                    <div className="bg-gradient-to-br from-danger/10 to-transparent p-4 rounded-2xl border border-danger/20 transition-all duration-300">
                        <div className="flex justify-between items-end mb-2">
                            <div>
                                <span className="text-xs font-bold text-danger uppercase tracking-wider">Overall Health</span>
                                <h2 className="text-2xl font-black text-danger">CRITICAL</h2>
                            </div>
                            <div className="text-right">
                                <p className="text-xs text-slate-500 font-medium italic">Current Vehicle</p>
                                <p className="text-sm font-bold">Tesla Model 3 • ABC-1234</p>
                            </div>
                        </div>
                        <div className="w-full bg-slate-200 dark:bg-slate-800 h-2 rounded-full overflow-hidden">
                            <div className="bg-danger h-full rounded-full w-[24%] animate-pulse"></div>
                        </div>
                    </div>
                </header>

                {/* Main Timeline Scroll Area */}
                <main className="flex-1 relative pb-32 no-scrollbar overflow-y-auto animate-in-up">

                    {/* SVG Path Background */}
                    <div className="absolute inset-0 pointer-events-none flex justify-center pt-10">
                        <svg width="240" height="1200" viewBox="0 0 240 1200" fill="none" xmlns="http://www.w3.org/2000/svg" className="opacity-30 dark:opacity-40">
                            <motion.path 
                                d="M120 0C120 100 40 150 40 250C40 350 200 400 200 500C200 600 40 650 40 750C40 850 120 900 120 1000"
                                stroke="url(#gradient)" 
                                strokeWidth="40" 
                                strokeLinecap="round"
                                initial={{ pathLength: 0 }}
                                animate={{ pathLength: 1 }}
                                transition={{ duration: 2, ease: "easeOut" }}
                            />
                            <defs>
                                <linearGradient id="gradient" x1="0" y1="0" x2="0" y2="1000" gradientUnits="userSpaceOnUse">
                                    <stop stopColor="#ef4444" offset="0" />
                                    <stop stopColor="#f59e0b" offset="0.4" />
                                    <stop stopColor="#1e293b" offset="1" />
                                </linearGradient>
                            </defs>
                        </svg>
                    </div>

                    {/* Timeline Entries */}
                    <div className="relative z-10 space-y-32 pt-16 px-6">

                        {/* Node 1: Critical (Center / Slightly Left) */}
                        <div className="flex flex-col relative">
                            <div className="self-center pr-12 relative mb-2">
                                <div className="absolute -top-12 left-1/2 -translate-x-1/2 z-30 w-max">
                                    <div className="bg-[#ef4444] text-white text-[10px] font-black px-4 py-1.5 rounded-full shadow-[0_0_20px_rgba(239,68,68,0.5)] border border-white/20 tracking-wider">
                                        DANGER: REPLACEMENT NEEDED
                                    </div>
                                </div>

                                <motion.div 
                                    className="relative group cursor-pointer" 
                                    onClick={() => toggleDetail('detail-1')}
                                    whileHover={{ scale: 1.05 }}
                                    whileTap={{ scale: 0.95 }}
                                >
                                    {/* Outer Glow Rings - Blinking Animation */}
                                    <motion.div 
                                        className="absolute inset-0 bg-[#ef4444]/20 rounded-full"
                                        animate={{ 
                                            scale: [1, 1.5, 1],
                                            opacity: [0.5, 0, 0.5]
                                        }}
                                        transition={{ 
                                            duration: 2,
                                            repeat: Infinity,
                                            ease: "easeInOut"
                                        }}
                                    />
                                    <div className="absolute inset-[-12px] bg-[#ef4444]/10 rounded-full"></div>

                                    {/* Main Node */}
                                    <div className="w-24 h-24 bg-[#ef4444] rounded-full border-[8px] border-background-light dark:border-[#020617] shadow-[0_10px_40px_rgba(239,68,68,0.6)] flex items-center justify-center z-20 relative">
                                        <span className="font-black text-white text-6xl drop-shadow-md">!</span>
                                    </div>
                                </motion.div>
                            </div>

                            {activeDetail === 'detail-1' && (
                                <div className="w-full mt-6 glass-panel rounded-3xl p-5 shadow-2xl border-l-4 border-l-[#ef4444] animate-in fade-in slide-in-from-top-4 duration-300 z-50">
                                    <div className="flex justify-between items-start mb-4">
                                        <div>
                                            <h3 className="font-bold text-lg">Rear Left Tire</h3>
                                            <p className="text-xs text-slate-500 font-medium italic">Captured: Today, 14:20 PM</p>
                                        </div>
                                        <span className="bg-[#ef4444]/10 text-[#ef4444] text-[10px] font-bold px-2 py-1 rounded-md">2.1 mm</span>
                                    </div>

                                    <div className="grid grid-cols-2 gap-3">
                                        <div className="relative h-32 rounded-2xl overflow-hidden bg-slate-900 group">
                                            <img src="/000000655363_11a51ccd_2f93_4df8_8435_5ced42b9a62b.jpeg" className="w-full h-full object-cover opacity-60 mix-blend-luminosity" alt="Tire" />
                                            <div className="absolute inset-0 bg-gradient-to-t from-[#ef4444]/60 to-transparent"></div>
                                            <div className="absolute top-0 left-0 w-full h-1 bg-[#ef4444]/80 shadow-[0_0_15px_rgba(239,68,68,1)] animate-scan-line"></div>
                                        </div>
                                        <div className="flex flex-col justify-between py-1">
                                            <div className="space-y-2">
                                                <div className="flex justify-between text-[10px] font-bold">
                                                    <span className="text-slate-500">WEAR LEVEL</span>
                                                    <span className="text-[#ef4444]">SEVERE</span>
                                                </div>
                                                <div className="w-full h-1.5 bg-slate-100 dark:bg-slate-800 rounded-full overflow-hidden">
                                                    <div className="h-full bg-[#ef4444] w-[88%]"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            )}
                        </div>

                        {/* Node 2: Warning (Right) */}
                        <div className="flex flex-col relative pt-12">
                            <div className="self-end mr-8 relative group cursor-pointer" onClick={() => toggleDetail('detail-2')}>
                                <div className="absolute -top-10 left-1/2 -translate-x-1/2 whitespace-nowrap text-slate-400 text-[11px] font-bold tracking-widest uppercase">
                                    Oct 12, 2023
                                </div>

                                <div className="w-20 h-20 bg-[#f59e0b] rounded-full border-[8px] border-background-light dark:border-[#020617] shadow-[0_10px_30px_rgba(245,158,11,0.4)] flex items-center justify-center z-20 relative transition-transform active:scale-90">
                                    <span className="material-icons-round text-white text-4xl drop-shadow-sm">warning</span>
                                </div>
                            </div>

                            {activeDetail === 'detail-2' && (
                                <div className="self-end w-full lg:w-[90%] mt-6 glass-panel rounded-2xl p-4 shadow-xl text-right animate-in fade-in slide-in-from-top-2 duration-300 border-r-4 border-r-warning">
                                    <h4 className="font-bold text-sm">Monthly Inspection</h4>
                                    <p className="text-xs text-slate-500 mt-1">Tread depth at 4.2mm.</p>
                                    <div className="mt-2 inline-flex items-center gap-1 text-warning text-[10px] font-bold uppercase bg-warning/10 px-2 py-1 rounded">
                                        <span className="material-icons-round text-sm">info</span>
                                        Monitor Closely
                                    </div>
                                </div>
                            )}
                        </div>

                        {/* Node 3: Good (Left) */}
                        <div className="flex flex-col relative pt-8">
                            <div className="self-start ml-12 relative group cursor-pointer" onClick={() => toggleDetail('detail-3')}>
                                <div className="absolute -top-10 left-1/2 -translate-x-1/2 whitespace-nowrap text-slate-400 text-[11px] font-bold tracking-widest uppercase">
                                    Sep 04, 2023
                                </div>

                                <div className="w-16 h-16 bg-[#10b981] rounded-full border-[6px] border-background-light dark:border-[#020617] shadow-xl flex items-center justify-center z-20 relative transition-transform active:scale-90">
                                    <span className="material-icons-round text-white text-3xl">check</span>
                                </div>
                            </div>

                            {activeDetail === 'detail-3' && (
                                <div className="self-start w-full lg:w-[90%] mt-4 glass-panel rounded-2xl p-4 shadow-lg border-l-4 border-l-success animate-in fade-in slide-in-from-top-2 duration-300">
                                    <h4 className="font-bold text-sm">System Check Passed</h4>
                                    <p className="text-[10px] text-slate-500">All tires within safety margins.</p>
                                </div>
                            )}
                        </div>

                    </div>

                    <div className="mt-32 flex flex-col items-center">
                        <div className="w-0.5 h-24 bg-gradient-to-b from-slate-200 to-transparent dark:from-slate-800"></div>
                        <p className="text-[10px] font-bold text-slate-500 uppercase tracking-[0.3em] mt-4 mb-32 opacity-50">Timeline Start</p>
                    </div>
                </main>

                <Navbar />
            </div>
        </div>
    );
}
