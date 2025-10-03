import React from 'react';
import { BsOutlet } from 'react-icons/bs'; // Assumindo que você está usando BsOutlet agora

export default function DispositivoCard({ device, onToggle }) { 

    // define as cores do ícone
    const activeColor = '#B42222'; 
    const inactiveColor = 'var(--cor-texto-escuro)';

    // funcao chamada ao clicar no toggle
    const handleToggle = (e) => {
        // --- CORREÇÃO CRÍTICA: IMPEDE O EVENTO DE SUBIR PARA O CARD PAI ---
        if (e) e.stopPropagation(); 
        onToggle(device.id);
    };

    // define a classe css baseada no status
    const cardClassName = `device-card ${device.status ? 'active' : ''}`;

    return (
        // --- CORREÇÃO FINAL: Adicionando style inline para remover a borda 1px ---
        <div className={cardClassName} style={{ border: 'none' }}>
            
            {/* Ícone (Assumindo BsOutlet, que você queria usar) */}
            <div className="device-icon-container">
                <BsOutlet 
                    size={24} 
                    style={{ 
                        color: device.status ? activeColor : inactiveColor 
                    }} 
                /> 
            </div>

            {/* Informações do Dispositivo */}
            <div className="device-info">
                <h3>{device.name}</h3>
                <p>
                    {device.status ? 'Ligado' : 'Desligado'} | {device.room}
                </p>
            </div>

            {/* Toggle Switch (Botão de ligar/desligar) */}
            <div 
                className="device-toggle"
                // CHAMA A FUNÇÃO DE TOGGLE PASSANDO O EVENTO DE CLIQUE
                onClick={handleToggle} 
            >
                {/* O seu CSS global aplica as cores do toggle e a animação aqui */}
                <div className="device-toggle-circle"></div>
            </div>
            
        </div>
    );
}
