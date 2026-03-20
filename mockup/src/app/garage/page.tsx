"use client";

import Navbar from "@/components/Navbar";
import Link from "next/link";

export default function GaragePage() {
    return (
        <div className="bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-100 font-sans min-h-screen">
            <div className="max-w-md mx-auto min-h-screen relative flex flex-col shadow-2xl bg-background-light dark:bg-background-dark overflow-hidden">

                {/* Header Section (Simpler for Garage) */}
                <header className="sticky top-0 z-40 glass-panel px-6 py-4 flex flex-col gap-4">
                    <div className="flex justify-between items-center">
                        <div className="flex items-center gap-3">
                            <div className="w-10 h-10 bg-primary rounded-xl flex items-center justify-center shadow-lg shadow-primary/30">
                                <span className="material-icons-round text-white">analytics</span>
                            </div>
                            <div>
                                <h1 className="font-extrabold text-lg leading-tight tracking-tight">TireGuard AI</h1>
                                <p className="text-[10px] text-slate-500 font-bold uppercase tracking-[0.2em]">Vehicle Management</p>
                            </div>
                        </div>
                        <Link href="/settings" className="w-10 h-10 rounded-full flex items-center justify-center hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors">
                            <span className="material-icons-round text-slate-500">settings</span>
                        </Link>
                    </div>
                </header>

                {/* Main Garage Content */}
                <main className="flex-1 relative pb-32 no-scrollbar overflow-y-auto animate-in-up px-6 pt-6">
                    <div className="flex justify-between items-center mb-6">
                        <h2 className="text-xl font-extrabold tracking-tight">Your Garage</h2>
                        <span className="text-xs font-bold text-slate-400 uppercase tracking-widest">3 Vehicles</span>
                    </div>

                    {/* Vehicle Cards List */}
                    <div className="space-y-4">

                        {/* Active Vehicle Card */}
                        <div className="glass-panel rounded-[2rem] p-5 border-l-4 border-l-primary shadow-xl relative overflow-hidden group cursor-pointer hover:scale-[1.02] transition-transform">
                            <div className="absolute top-0 right-0 p-4">
                                <span className="bg-primary/10 text-primary text-[10px] font-bold px-3 py-1 rounded-full border border-primary/20">ACTIVE</span>
                            </div>
                            <div className="flex gap-5 items-center">
                                <div className="w-24 h-24 rounded-2xl bg-slate-100 dark:bg-slate-800 flex items-center justify-center overflow-hidden shadow-inner">
                                    <img src="https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=200&auto=format&fit=crop" className="w-full h-full object-cover" alt="Tesla Model 3" />
                                </div>
                                <div className="flex-1">
                                    <h3 className="font-extrabold text-lg leading-tight">Tesla Model 3</h3>
                                    <p className="text-xs text-slate-500 font-mono">ABC-1234</p>
                                    <div className="mt-3 flex items-center gap-2">
                                        <span className="text-xs font-bold text-danger">Health: 24%</span>
                                        <div className="flex-1 h-1 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                            <div className="h-full bg-danger w-[24%]"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* Secondary Vehicle */}
                        <div className="glass-panel rounded-[2rem] p-5 border-l-4 border-l-success/30 shadow-md opacity-80 hover:opacity-100 transition-all cursor-pointer hover:scale-[1.02]">
                            <div className="flex gap-5 items-center">
                                <div className="w-20 h-20 rounded-2xl bg-slate-100 dark:bg-slate-800 flex items-center justify-center overflow-hidden grayscale group-hover:grayscale-0 transition-all">
                                    <img src="https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=200&auto=format&fit=crop" className="w-full h-full object-cover" alt="Porsche Taycan" />
                                </div>
                                <div className="flex-1">
                                    <h3 className="font-bold text-md leading-tight">Porsche Taycan</h3>
                                    <p className="text-[10px] text-slate-500 font-mono">XYZ-9876</p>
                                    <div className="mt-2 flex items-center gap-2">
                                        <span className="text-[10px] font-bold text-success">Health: 92%</span>
                                        <div className="flex-1 h-1 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                            <div className="h-full bg-success w-[92%]"></div>
                                        </div>
                                    </div>
                                </div>
                                <span className="material-icons-round text-slate-300">chevron_right</span>
                            </div>
                        </div>

                        {/* Third Vehicle */}
                        <div className="glass-panel rounded-[2rem] p-5 border-l-4 border-l-warning/30 shadow-md opacity-80 hover:opacity-100 transition-all cursor-pointer hover:scale-[1.02]">
                            <div className="flex gap-5 items-center">
                                <div className="w-20 h-20 rounded-2xl bg-slate-100 dark:bg-slate-800 flex items-center justify-center overflow-hidden grayscale group-hover:grayscale-0 transition-all">
                                    <img src="https://images.unsplash.com/photo-1555215695-3004980ad54e?q=80&w=200&auto=format&fit=crop" className="w-full h-full object-cover" alt="BMW i4" />
                                </div>
                                <div className="flex-1">
                                    <h3 className="font-bold text-md leading-tight">BMW i4 M50</h3>
                                    <p className="text-[10px] text-slate-500 font-mono">M-POWER-1</p>
                                    <div className="mt-2 flex items-center gap-2">
                                        <span className="text-[10px] font-bold text-warning">Health: 72%</span>
                                        <div className="flex-1 h-1 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                            <div className="h-full bg-warning w-[72%]"></div>
                                        </div>
                                    </div>
                                </div>
                                <span className="material-icons-round text-slate-300">chevron_right</span>
                            </div>
                        </div>

                        {/* Add New Vehicle Content */}
                        <button className="w-full py-8 border-2 border-dashed border-slate-300 dark:border-slate-700 rounded-[2rem] flex flex-col items-center justify-center gap-2 hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors group">
                            <div className="w-12 h-12 rounded-full bg-slate-100 dark:bg-slate-800 flex items-center justify-center group-hover:bg-primary/10 group-hover:text-primary transition-all">
                                <span className="material-icons-round text-slate-400 group-hover:text-primary">add</span>
                            </div>
                            <span className="text-xs font-bold text-slate-500 uppercase tracking-widest group-hover:text-primary transition-colors">Register New Vehicle</span>
                        </button>

                    </div>
                </main>

                <Navbar />
            </div>
        </div>
    );
}
