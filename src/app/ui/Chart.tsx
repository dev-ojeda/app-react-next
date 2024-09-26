'use client'
import React from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

const data = [
    { name: 'Enero', ventas: 4000, gastos: 2400 },
    { name: 'Febrero', ventas: 3000, gastos: 1398 },
    { name: 'Marzo', ventas: 2000, gastos: 9800 },
    { name: 'Abril', ventas: 2780, gastos: 3908 },
    { name: 'Mayo', ventas: 1890, gastos: 4800 },
];

const Chart = () => {
    return (
        <ResponsiveContainer width="100%" height={400}>
            <BarChart data={data}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="name" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Bar dataKey="ventas" fill="#8884d8" />
                <Bar dataKey="gastos" fill="#82ca9d" />
            </BarChart>
        </ResponsiveContainer>
    );
};

export default Chart;
