"use client";

import { useState } from "react";
import Navbar from "@/components/Navbar";
import Link from "next/link";
import { motion, AnimatePresence } from "framer-motion";

export default function ScanPage() {
    const [isScanning, setIsScanning] = useState(false);
    const [uploadedImage, setUploadedImage] = useState<string | null>(null);

    const handleUpload = () => {
        // Simulating upload/scan process
        setIsScanning(true);
        setTimeout(() => {
            setUploadedImage("/000000655363_11a51ccd_2f93_4df8_8435_5ced42b9a62b.jpeg"); // Using the known local image as mockup
            setIsScanning(false);
        }, 3000);
    };

    return (
        <div className="bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-100 font-sans min-h-screen">
            <div className="max-w-md mx-auto min-h-screen relative flex flex-col shadow-2xl bg-background-light dark:bg-background-dark overflow-hidden">
                
                {/* Header Section */}
                <header className="absolute top-0 left-0 right-0 z-40 p-6 flex justify-between items-center bg-gradient-to-b from-background-light/90 via-background-light/50 to-transparent dark:from-background-dark/90 dark:via-background-dark/50">
                    <Link href="/timeline" className="w-10 h-10 rounded-full glass-panel flex items-center justify-center hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors">
                        <span className="material-icons-round text-slate-500 dark:text-slate-300">arrow_back</span>
                    </Link>
                    <div className="glass-panel px-4 py-2 rounded-full flex items-center gap-2">
                        <div className="w-2 h-2 rounded-full bg-primary animate-pulse"></div>
                        <span className="text-[10px] font-bold uppercase tracking-widest text-primary">AI Scanner Active</span>
                    </div>
                    <div className="w-10"></div> {/* Spacer for center alignment */}
                </header>

                {/* Main Scan Area */}
                <main className="flex-1 relative flex flex-col items-center justify-center p-6">
                    
                    {/* Background Grid Animation for "Big Data" feel */}
                    <div className="absolute inset-0 z-0 opacity-20 dark:opacity-10 pointer-events-none overflow-hidden">
                         <div className="absolute inset-0 bg-[linear-gradient(to_right,#80808012_1px,transparent_1px),linear-gradient(to_bottom,#80808012_1px,transparent_1px)] bg-[size:24px_24px]"></div>
                         <motion.div 
                            className="absolute inset-0 bg-gradient-to-b from-primary/5 via-transparent to-transparent"
                            animate={{ translateY: ["-100%", "100%"] }}
                            transition={{ duration: 3, repeat: Infinity, ease: "linear" }}
                         />
                    </div>


                    <AnimatePresence mode="wait">
                        {!uploadedImage ? (
                            <motion.div 
                                key="upload-state"
                                initial={{ opacity: 0, scale: 0.9 }}
                                animate={{ opacity: 1, scale: 1 }}
                                exit={{ opacity: 0, scale: 0.9 }}
                                className="w-full relative z-10 flex flex-col items-center gap-6"
                            >
                                {/* Camera Mode (Active) */}
                                {isScanning ? (
                                    <div className="relative w-full aspect-[3/4] rounded-[2.5rem] overflow-hidden bg-black shadow-2xl">
                                        {/* Mock Camera Feed (simulated with static image/video placeholder for demo) */}
                                        <div className="absolute inset-0 bg-slate-900 flex items-center justify-center">
                                             {/* Live Camera Simulation */}
                                             <video 
                                                className="absolute inset-0 w-full h-full object-cover opacity-80"
                                                autoPlay muted loop playsInline
                                                poster="/000000655363_11a51ccd_2f93_4df8_8435_5ced42b9a62b.jpeg"
                                             ></video>
                                             
                                             {/* Augmented Reliability Grid */}
                                             <div className="absolute inset-0 bg-[linear-gradient(rgba(0,255,0,0.1)_1px,transparent_1px),linear-gradient(90deg,rgba(0,255,0,0.1)_1px,transparent_1px)] bg-[size:40px_40px] opacity-20"></div>
                                             
                                             {/* Scanning Laser */}
                                             <motion.div 
                                                className="absolute top-0 left-0 w-full h-1 bg-primary shadow-[0_0_15px_rgba(239,68,68,1)] z-10"
                                                animate={{ top: ["0%", "100%", "0%"] }}
                                                transition={{ duration: 3, repeat: Infinity, ease: "linear" }}
                                             />
                                             
                                             <div className="absolute bottom-8 left-0 right-0 flex justify-center z-20">
                                                 <button 
                                                    className="w-20 h-20 rounded-full border-[6px] border-white flex items-center justify-center cursor-pointer active:scale-90 transition-transform"
                                                    onClick={() => {
                                                        // Capture
                                                        setTimeout(() => setUploadedImage("/000000655363_11a51ccd_2f93_4df8_8435_5ced42b9a62b.jpeg"), 500);
                                                        setIsScanning(false);
                                                    }}
                                                 >
                                                     <div className="w-16 h-16 rounded-full bg-white"></div>
                                                 </button>
                                             </div>
                                        </div>
                                    </div>
                                ) : (
                                    /* Main Menu: Choose Camera or Upload */
                                    <div className="flex flex-col gap-4 w-full">
                                        <button 
                                            className="group relative w-full aspect-[4/3] rounded-[2.5rem] bg-slate-900 overflow-hidden shadow-xl flex flex-col items-center justify-center cursor-pointer transition-transform active:scale-95"
                                            onClick={() => setIsScanning(true)}
                                        >
                                            <div className="absolute inset-0 bg-gradient-to-br from-slate-800 to-black group-hover:scale-105 transition-transform duration-500"></div>
                                            <div className="z-10 w-20 h-20 rounded-full bg-white/10 backdrop-blur-md flex items-center justify-center mb-4 group-hover:bg-primary transition-colors">
                                                <span className="material-icons-round text-white text-4xl">add_a_photo</span>
                                            </div>
                                            <h3 className="z-10 text-white font-bold text-xl tracking-wide">Open Camera</h3>
                                            <p className="z-10 text-slate-400 text-xs mt-1">Real-time AI Analysis</p>
                                        </button>

                                        <div className="flex items-center gap-4 w-full">
                                            <div className="h-[1px] bg-slate-200 dark:bg-slate-800 flex-1"></div>
                                            <span className="text-xs font-bold text-slate-400">OR</span>
                                            <div className="h-[1px] bg-slate-200 dark:bg-slate-800 flex-1"></div>
                                        </div>

                                        <button 
                                            className="w-full py-4 rounded-2xl border-2 border-dashed border-slate-300 dark:border-slate-700 text-slate-500 dark:text-slate-400 font-bold flex items-center justify-center gap-2 hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors"
                                            onClick={handleUpload}
                                        >
                                            <span className="material-icons-round">upload_file</span>
                                            Upload from Gallery
                                        </button>
                                    </div>
                                )}
                            </motion.div>
                        ) : (
                            <motion.div 
                                key="result-state"
                                initial={{ opacity: 0, y: 20 }}
                                animate={{ opacity: 1, y: 0 }}
                                className="w-full relative z-10 flex flex-col gap-6"
                            >
                                {/* Image Preview with Data Overlay */}
                                <div className="relative w-full aspect-[4/3] rounded-3xl overflow-hidden shadow-2xl border border-white/10 group">
                                    <img src={uploadedImage} alt="Analyzed Tire" className="w-full h-full object-cover" />
                                    <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent"></div>
                                    
                                    {/* Data Points Overlay (Mockup) */}
                                    <div className="absolute top-1/4 left-1/4 w-3 h-3 bg-primary rounded-full animate-ping"></div>
                                    <div className="absolute top-1/4 left-1/4 w-3 h-3 bg-primary rounded-full border-2 border-white shadow-[0_0_10px_rgba(239,68,68,0.8)]"></div>
                                    
                                    <div className="absolute bottom-1/3 right-1/3 w-3 h-3 bg-warning rounded-full animate-ping delay-75"></div>
                                    <div className="absolute bottom-1/3 right-1/3 w-3 h-3 bg-warning rounded-full border-2 border-white shadow-[0_0_10px_rgba(245,158,11,0.8)]"></div>

                                    {/* Analysis Badge */}
                                    <div className="absolute bottom-4 left-4 right-4 bg-white/10 backdrop-blur-md border border-white/20 p-4 rounded-2xl flex justify-between items-center">
                                        <div>
                                            <p className="text-[10px] text-slate-300 font-bold uppercase tracking-wider">Detected Issue</p>
                                            <h4 className="text-white font-bold text-lg flex items-center gap-2">
                                                <span className="w-2 h-2 rounded-full bg-primary"></span>
                                                Uneven Wear
                                            </h4>
                                        </div>
                                        <div className="bg-primary px-3 py-1 rounded-lg text-white text-xs font-bold">98% Confidence</div>
                                    </div>
                                </div>

                                {/* Analytics Details Card */}
                                <div className="glass-panel p-6 rounded-[2rem] space-y-4">
                                    <div className="flex items-center justify-between">
                                        <h3 className="font-bold text-slate-700 dark:text-slate-200">Data Analytics</h3>
                                        <span className="text-[10px] bg-slate-100 dark:bg-slate-800 text-slate-500 px-2 py-1 rounded-md font-mono">ID: #TR-8821</span>
                                    </div>
                                    
                                    <div className="space-y-3">
                                        <div className="flex justify-between items-center text-sm">
                                            <span className="text-slate-500">Tread Depth Avg</span>
                                            <span className="font-bold text-slate-900 dark:text-white">3.4 mm</span>
                                        </div>
                                        <div className="w-full h-2 bg-slate-100 dark:bg-slate-800 rounded-full overflow-hidden">
                                            <div className="h-full bg-warning w-[45%] rounded-full"></div>
                                        </div>
                                        
                                        <div className="flex justify-between items-center text-sm mt-2">
                                            <span className="text-slate-500">Surface Integrity</span>
                                            <span className="font-bold text-slate-900 dark:text-white">Critical</span>
                                        </div>
                                        <div className="w-full h-2 bg-slate-100 dark:bg-slate-800 rounded-full overflow-hidden">
                                            <div className="h-full bg-primary w-[82%] rounded-full"></div>
                                        </div>
                                    </div>

                                    <div className="pt-4 mt-2 border-t border-slate-200 dark:border-slate-800 flex gap-3">
                                        <button className="flex-1 bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 font-bold text-xs py-3 rounded-xl hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors" onClick={() => setUploadedImage(null)}>
                                            RESCAN
                                        </button>
                                        <button className="flex-1 bg-primary text-white font-bold text-xs py-3 rounded-xl shadow-lg shadow-primary/20 hover:bg-red-600 transition-colors flex items-center justify-center gap-2">
                                            <span className="material-icons-round text-sm">save</span>
                                            SAVE REPORT
                                        </button>
                                    </div>
                                </div>
                            </motion.div>
                        )}
                    </AnimatePresence>
                </main>
                
                <Navbar />
            </div>
        </div>
    );
}
