// >>>>>>>>>>> PAGINA EM JSX

import React, { useState, useEffect, useCallback } from 'react';

// --- Ícones ---
const FaUser = ({ size = 24, color = 'currentColor', style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
        <circle cx="12" cy="7" r="4"></circle>
    </svg>
);

const FaEdit = ({ size = 18, color = 'currentColor', style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"></path>
    </svg>
);

const FaChevronRight = ({ size = 20, color = 'currentColor', style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <polyline points="9 18 15 12 9 6"></polyline>
    </svg>
);

const FaZap = ({ size = 20, color = 'currentColor', style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon>
    </svg>
);

const FaTarget = ({ size = 20, color = 'currentColor', style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <circle cx="12" cy="12" r="10"></circle>
        <circle cx="12" cy="12" r="6"></circle>
        <circle cx="12" cy="12" r="2"></circle>
    </svg>
);

// Componente para um Item de Configuração (reutilizável)
const ActionItem = ({ icon: Icon, title, description, action, primaryColor, cardBackground, textColor, secondaryTextColor, borderColor, isLast = false }) => {
    return (
        <div 
            onClick={action} 
            style={{
                display: 'flex',
                alignItems: 'center',
                padding: '12px 0',
                cursor: 'pointer', 
                borderBottom: isLast ? 'none' : `1px solid ${borderColor}`,
                transition: 'background-color 0.1s',
            }}
            onMouseOver={e => e.currentTarget.style.backgroundColor = 'rgba(0, 0, 0, 0.03)'}
            onMouseOut={e => e.currentTarget.style.backgroundColor = cardBackground}
        >
            <Icon size={20} color={primaryColor} style={{ marginRight: '15px' }} />
            <div style={{ flexGrow: 1 }}>
                <p style={{ margin: 0, fontWeight: 'bold', color: textColor, fontSize: '15px' }}>{title}</p>
                {description && <p style={{ margin: 0, color: secondaryTextColor, fontSize: '12px', marginTop: '2px' }}>{description}</p>}
            </div>
            <FaChevronRight size={16} color={secondaryTextColor} />
        </div>
    );
};

// Componente Principal da Tela de Perfil
export default function Perfil() {
    // Cores fixas e primárias
    const PRIMARY_RED = '#B42222'; 
    const BORDER_COLOR = '#E0E0E0';
    const MAIN_TEXT_COLOR_REQUESTED = '#A6A6A6'; 

    // --- Lógica de Tema ---
    // Simulamos um tema para o Perfil, mas as opções de troca ficam no 'Mais'
    const [theme, setTheme] = useState('Claro'); 

    // Mapeamento de cores baseado no tema
    const themeStyles = {
        'Claro': {
            pageBackground: '#FFFFFF', 
            cardBackground: '#F6F6F6', 
            textColor: MAIN_TEXT_COLOR_REQUESTED, 
            secondaryTextColor: MAIN_TEXT_COLOR_REQUESTED, 
            reverseTextColor: '#FFFFFF',
            borderColor: BORDER_COLOR,
        },
        'Escuro': {
            pageBackground: '#1C1C1E', 
            cardBackground: '#2C2C2E', 
            textColor: '#FFFFFF', 
            secondaryTextColor: '#B0B0B0', 
            reverseTextColor: '#000000',
            borderColor: '#38383A',
        }
    };

    const currentTheme = themeStyles[theme];

    const { 
        pageBackground, 
        cardBackground, 
        textColor, 
        secondaryTextColor, 
        borderColor 
    } = currentTheme;

    // Aplicar a cor de fundo da página ao body
    useEffect(() => {
        document.body.style.backgroundColor = pageBackground;
        return () => {
            document.body.style.backgroundColor = ''; 
        };
    }, [pageBackground]);

    // Dados de exemplo
    const userName = "Manoella Ginez";
    const userEmail = "ginez.mano@gmail.com";
    const status = "CONTA ATIVA";

    return (
        <div className="perfil-page-container" style={{ 
            display: 'flex', 
            flexDirection: 'column', 
            minHeight: '100vh', 
            maxWidth: '450px',
            margin: '0 auto',
            backgroundColor: pageBackground,
            color: secondaryTextColor, 
            overflowY: 'auto', 
            transition: 'background-color 0.3s'
        }}>
            <style>
                {`
                    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap');
                    
                    body, html, #root {
                        font-family: 'Inter', sans-serif;
                        height: 100%;
                        margin: 0;
                        padding: 0;
                    }
                `}
            </style>

            {/* CABEÇALHO */}
            <div className="page-header" style={{ padding: '20px 15px 15px', backgroundColor: pageBackground }}>
                <h1 style={{ 
                    color: PRIMARY_RED, 
                    fontSize: '28px', 
                    margin: '0', 
                    textAlign: 'left' 
                }}>
                    Perfil
                </h1>
                <p style={{ color: secondaryTextColor, fontSize: '17px', margin: '5px 0 0', textAlign: 'left' }}>
                    Seu espaço pessoal e dados de consumo
                </p>
            </div>

            {/* CONTEÚDO PRINCIPAL COM PADDING HORIZONTAL */}
            <div style={{ padding: '0 15px', flexGrow: 1 }}>

                {/* 1. CARTÃO DE INFORMAÇÕES DO USUÁRIO */}
                <div style={{
                    backgroundColor: cardBackground, 
                    borderRadius: '12px',
                    padding: '20px',
                    marginBottom: '20px',
                    boxShadow: '0 2px 5px rgba(0, 0, 0, 0.05)',
                    transition: 'background-color 0.3s'
                }}>
                    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '15px' }}>
                        <div style={{ 
                            width: '50px', 
                            height: '50px', 
                            borderRadius: '50%', 
                            backgroundColor: pageBackground, 
                            display: 'flex', 
                            alignItems: 'center', 
                            justifyContent: 'center',
                            transition: 'background-color 0.3s'
                        }}>
                            <FaUser size={30} color={PRIMARY_RED} />
                        </div>
                        <FaEdit color={secondaryTextColor} style={{ cursor: 'pointer' }} onClick={() => console.log('Editar Perfil')} />
                    </div>
                    <p style={{ margin: 0, fontSize: '18px', fontWeight: 'bold', color: textColor }}>{userName}</p>
                    <p style={{ margin: '3px 0', fontSize: '14px', color: secondaryTextColor }}>{userEmail}</p>
                    <span style={{ 
                        display: 'inline-block', 
                        padding: '3px 8px', 
                        borderRadius: '5px', 
                        fontSize: '11px', 
                        fontWeight: 'bold',
                        color: theme === 'Claro' ? '#FFFFFF' : '#000000', 
                        backgroundColor: PRIMARY_RED,
                        marginTop: '10px'
                    }}>{status}</span>
                </div>

                {/* 2. CARTÃO DE ESTATÍSTICAS DE USO */}
                <h3 style={{ color: textColor, fontSize: '16px', margin: '0 0 10px', textAlign: 'left' }}>Estatísticas de uso</h3>
                <div style={{
                    backgroundColor: cardBackground, 
                    borderRadius: '12px',
                    padding: '20px',
                    marginBottom: '20px',
                    boxShadow: '0 2px 5px rgba(0, 0, 0, 0.05)',
                    transition: 'background-color 0.3s'
                }}>
                    <div style={{ display: 'flex', flexWrap: 'wrap', justifyContent: 'space-between' }}>
                        
                        <div style={{ width: '45%', textAlign: 'center', marginBottom: '15px' }}>
                            <p style={{ margin: '0 0 5px', fontSize: '24px', fontWeight: 'bold', color: textColor }}>25</p>
                            <p style={{ margin: 0, fontSize: '12px', color: secondaryTextColor }}>Dias de uso</p>
                        </div>

                        <div style={{ width: '45%', textAlign: 'center', marginBottom: '15px' }}>
                            <p style={{ margin: '0 0 5px', fontSize: '24px', fontWeight: 'bold', color: textColor }}>12</p>
                            <p style={{ margin: 0, fontSize: '12px', color: secondaryTextColor }}>Dispositivos</p>
                        </div>
                        
                        <div style={{ width: '45%', textAlign: 'center' }}>
                            <p style={{ margin: '0 0 5px', fontSize: '24px', fontWeight: 'bold', color: textColor }}>R$ 87,50</p>
                            <p style={{ margin: 0, fontSize: '12px', color: secondaryTextColor }}>Economia total</p>
                        </div>
                        
                        <div style={{ width: '45%', textAlign: 'center' }}>
                            <p style={{ margin: '0 0 5px', fontSize: '24px', fontWeight: 'bold', color: textColor }}>15%</p>
                            <p style={{ margin: 0, fontSize: '12px', color: secondaryTextColor }}>Redução consumo</p>
                        </div>
                    </div>
                </div>

                {/* 3. AÇÕES RÁPIDAS (Novo) */}
                <h3 style={{ color: textColor, fontSize: '16px', margin: '0 0 10px', textAlign: 'left' }}>Ações de energia</h3>
                <div style={{
                    backgroundColor: cardBackground, 
                    borderRadius: '12px',
                    padding: '0 20px',
                    marginBottom: '20px',
                    boxShadow: '0 2px 5px rgba(0, 0, 0, 0.05)',
                    transition: 'background-color 0.3s'
                }}>
                    <ActionItem 
                        icon={FaZap} 
                        title="Meus dispositivos" 
                        description="Gerencie os aparelhos conectados" 
                        action={() => console.log('Abrir Meus Dispositivos')} 
                        primaryColor={PRIMARY_RED} cardBackground={cardBackground} textColor={textColor} secondaryTextColor={secondaryTextColor} borderColor={borderColor}
                    />
                    <ActionItem 
                        icon={FaTarget} 
                        title="Metas de economia" 
                        description="Defina e acompanhe seus objetivos" 
                        action={() => console.log('Abrir Metas de Economia')} 
                        isLast={true}
                        primaryColor={PRIMARY_RED} cardBackground={cardBackground} textColor={textColor} secondaryTextColor={secondaryTextColor} borderColor={borderColor}
                    />
                </div>

                {/* 4. BOTÃO DE SAIR E RODAPÉ */}
                <button
                    onClick={() => console.log('Sair da Conta')}
                    style={{
                        fontFamily: 'Inter, sans-serif', 
                        width: '100%',
                        padding: '15px',
                        borderRadius: '12px',
                        border: 'none',
                        backgroundColor: PRIMARY_RED, 
                        color: currentTheme.reverseTextColor, 
                        fontSize: '16px',
                        fontWeight: 'bold',
                        cursor: 'pointer',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center', 
                        transition: 'background-color 0.2s, color 0.3s',
                        marginBottom: '30px',
                        boxShadow: '0 2px 5px rgba(0, 0, 0, 0.05)'
                    }}
                    onMouseOver={e => e.currentTarget.style.backgroundColor = '#B3000E'}
                    onMouseOut={e => e.currentTarget.style.backgroundColor = PRIMARY_RED}
                >
                    SAIR DA CONTA
                </button>

                <div style={{ textAlign: 'center', color: secondaryTextColor, fontSize: '12px', marginBottom: '20px', paddingBottom: '50px' }}>
                    <p style={{ margin: '5px 0' }}>© 2025 Voltrix. Todos os direitos reservados.</p>
                </div>

            </div>
        </div>
    );
}
