import React from 'react';
import DispositivoCard from "../../components/DispositivoCard.jsx";
// Importações de ícones Fa (Font Awesome)
import { FaBolt, FaDollarSign, FaPlus, FaPowerOff, FaSun } from 'react-icons/fa'; 
// Importações de navegação (corrigido)
import { Link, useNavigate } from 'react-router-dom';

export default function Inicio({ devices, onToggleDevice }) {
    const navigate = useNavigate();
    const activeCount = devices.filter(d => d.status).length;
    
    // Função para lidar com o clique no card (funcionalidade de detalhe)
    const handleCardClick = (deviceId) => {
        navigate(`/dispositivo/${deviceId}`);
    };

    // Cor específica para os títulos
    const titleColor = '#B42222';  

    return (
        <div className="device-list-container">
            
            {/* HEADER E SAUDAÇÃO */}
            <div style={{ padding: '15px 0', color: 'var(--cor-texto-claro)' }}>
                <h1 
                    className="page-title" 
                    style={{ margin: '0 0 5px', fontSize: '28px', color: titleColor }}
                >
                    Início
                </h1>
                <p style={{ fontSize: '17px', color: 'var(--cor-texto-escuro)' }}>Olá, Manoella</p>
            </div>
            
            {/* CARDS DE STATUS */}
            <div className="status-cards-container">
                <div className="status-card">
                    <div className="card-icon-circle" style={{ backgroundColor: 'var(--cor-sucesso)' }}>
                        <FaPowerOff style={{ color: 'white' }} />
                    </div>
                    <p className="card-label">Ativos</p>
                    <p className="card-value" style={{ color: 'var(--cor-texto-claro)' }}>{activeCount}</p>
                </div>

                <div className="status-card">
                    <div className="card-icon-circle" style={{ backgroundColor: titleColor }}>
                        <FaDollarSign style={{ color: 'white' }} />
                    </div>
                    <p className="card-label">Custo hoje</p>
                    <p className="card-value" style={{ color: 'var(--cor-texto-claro)' }}>R$ 0,00</p>
                </div>
            </div>
            
            {/* Card: Consumo Atual */}
            <div className="consumption-card">
                <h3 className="card-label">Consumo atual</h3>
                <p className="consumption-value">0,00</p>
                <p className="consumption-unit">kWh em uso agora</p>
                <div className="consumption-graph-placeholder"></div>
            </div>

            {/* BOTÃO ADICIONAR DISPOSITIVO */}
            <Link to="/adicionar-dispositivo" className="add-device-button">
                ADICIONAR DISPOSITIVO
            </Link>
            
            {/* LISTA DE DISPOSITIVOS */}
            <h2 style={{ marginTop: '30px', fontSize: '20px', color: titleColor }}>
                Meus dispositivos
            </h2>
            
            {devices.map(device => (
                <div 
                    key={device.id} 
                    onClick={() => handleCardClick(device.id)}
                    style={{ cursor: 'pointer', marginBottom: '15px' }} 
                >
                    <DispositivoCard 
                        device={device} 
                        onToggle={onToggleDevice} 
                    />
                </div>
            ))}

            {devices.length === 0 && (
                <p style={{ textAlign: 'center', color: 'var(--cor-texto-escuro)' }}>Nenhum dispositivo instalado</p>
            )}
            
            {/* --- INÍCIO: SEÇÃO PAINEL SOLAR (agora primeiro) --- */}
            <h2 
                style={{ marginTop: '30px', fontSize: '20px', color: titleColor, marginBottom: '15px' }}
            >
                Painel solar
            </h2>

            <div 
                className="consumption-card" 
                style={{ 
                    marginBottom: '20px', 
                    padding: '12px 15px',
                    borderRadius: '12px', 
                    backgroundColor: 'var(--cor-fundo-card)',
                    boxShadow: '0 4px 10px rgba(0, 0, 0, 0.05)',
                    cursor: 'pointer',
                    transition: 'transform 0.2s',
                    border: 'none', 
                }}
                onClick={() => navigate('/painel-solar')}
                onMouseOver={e => e.currentTarget.style.transform = 'translateY(-2px)'}
                onMouseOut={e => e.currentTarget.style.transform = 'translateY(0)'}
            >
                <div style={{ display: 'flex', alignItems: 'center' }}>
                    <FaSun style={{ color: titleColor, marginRight: '10px', fontSize: '24px' }} />
                    <div>
                        <h3 className="card-label" style={{ fontWeight: 'bold', color: 'var(--cor-texto-claro)', margin: '0 0 3px 0', fontSize: '16px' }}>
                            Configure seu painel solar
                        </h3>
                        <p style={{ color: 'var(--cor-texto-escuro)', fontSize: '13.5px', margin: 0 }}>
                            Acesse as configurações do seu sistema solar
                        </p>
                    </div>
                </div>
            </div>
            {/* --- FIM: SEÇÃO PAINEL SOLAR --- */}

            {/* --- INÍCIO: SEÇÃO AÇÕES INTELIGENTES (agora embaixo) --- */}
            <h2 
                style={{ marginTop: '30px', fontSize: '20px', color: titleColor, marginBottom: '15px' }}
            >
                Ações inteligentes
            </h2>

            <div 
                className="consumption-card" 
                style={{ 
                    marginBottom: '20px', 
                    padding: '12px 15px',
                    borderRadius: '12px', 
                    backgroundColor: 'var(--cor-fundo-card)',
                    boxShadow: '0 4px 10px rgba(0, 0, 0, 0.05)',
                    cursor: 'pointer',
                    transition: 'transform 0.2s',
                    border: 'none', 
                }}
                onClick={() => navigate('/gerenciar')}
                onMouseOver={e => e.currentTarget.style.transform = 'translateY(-2px)'}
                onMouseOut={e => e.currentTarget.style.transform = 'translateY(0)'}
            >
                <div style={{ display: 'flex', alignItems: 'center' }}>
                    <FaBolt style={{ color: titleColor, marginRight: '10px', fontSize: '24px' }} />
                    <div>
                        <h3 className="card-label" style={{ fontWeight: 'bold', color: 'var(--cor-texto-claro)', margin: '0 0 3px 0', fontSize: '16px' }}>
                            Gerenciar desligamento e economia
                        </h3>
                        <p style={{ color: 'var(--cor-texto-escuro)', fontSize: '13.5px', margin: 0 }}>
                            Programe horários e otimize o consumo de seus dispositivos
                        </p>
                    </div>
                </div>
            </div>
            {/* --- FIM: SEÇÃO AÇÕES INTELIGENTES --- */}
        </div>
    );
}
