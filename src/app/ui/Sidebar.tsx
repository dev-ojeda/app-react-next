'use client'

import React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation'
const Sidebar = () => {
    const pathname = usePathname()
    return (
        <nav>
            <div style={{ width: '250px', background: '#333', color: '#fff', height: '100vh', padding: '20px' }}>
                <h2></h2>
                <ul style={{ listStyleType: 'none', padding: 0 }}>
                    <li>
                        <Link className={`link ${pathname === '/' ? 'active' : ''}`} href="/">
                            Home
                        </Link>
                    </li>
                    <li>
                        <Link
                            className={`link ${pathname === '/dashboard' ? 'active' : ''}`}
                            href="/dashboard"
                        >
                            Chart
                        </Link>
                    </li>
                </ul>
            </div>
        </nav>
    );
};

export default Sidebar;
