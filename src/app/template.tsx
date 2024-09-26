import React from "react";

export default function Template({ children }: { children: React.ReactNode }) {
    return <div id="principal" className="min-h-screen">{children}</div>
}