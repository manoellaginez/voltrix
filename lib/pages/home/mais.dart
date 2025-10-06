// >>>>>>>>>>> PAGINA EM JSX

import React, { useState, useEffect, useCallback } from 'react';

// --- Ícones ---
const FaChevronRight = ({ size = 20, color = 'currentColor', style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <polyline points="9 18 15 12 9 6"></polyline>
    </svg>
);

// Configurações Pessoais
const FaSettingsPerson = ({ size = 20, color = 'currentColor', style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
        <circle cx="9" cy="7" r="4"></circle>
        <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
    </svg>
);

const FaShield = ({ size = 20, color = 'currentColor', style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
    </svg>
);

const FaBell = ({ size = 20, color = 'currentColor', style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
    </svg>
);

const FaTheme = ({ size = 20, color = 'currentColor', style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"></path>
    </svg>
);

const FaGlobe = ({ size = 20, color = 'currentColor', style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <circle cx="12" cy="12" r="10"></circle>
        <line x1="2" y1="12" x2="22" y2="12"></line>
        <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path>
    </svg>
);

// Ícones de Suporte e Legal
const FaHelpCircle = ({ size = 20, color = 'currentColor', style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <circle cx="12" cy="12" r="10"></circle>
        <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path>
        <line x1="12" y1="17" x2="12.01" y2="17"></line>
    </svg>
);

const FaFileText = ({ size = 20, color = 'currentColor', style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"></path>
        <polyline points="14 2 14 8 20 8"></polyline>
        <line x1="16" y1="13" x2="8" y2="13"></line>
        <line x1="16" y1="17" x2="8" y2="17"></line>
        <line x1="10" y1="9" x2="8" y2="9"></line>
    </svg>
);

const FaLock = ({ size = 20, color = 'currentColor', style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
    </svg>
);

const FaAppInfo = ({ size = 20, color = 'currentColor', style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <circle cx="12" cy="12" r="10"></circle>
        <line x1="12" y1="16" x2="12" y2="12"></line>
        <line x1="12" y1="8" x2="12.01" y2="8"></line>
    </svg>
);

// Componente para um Item de Configuração (reutilizável, com suporte a toggle e custom content)
const ConfigItem = ({ icon: Icon, title, description, action = null, isToggle = false, isLast = false, isToggled, primaryColor, cardBackground, textColor, secondaryTextColor, borderColor, customContent = null }) => {
    
    // Renderiza o switch ou a seta/conteúdo customizado
    const renderAction = () => {
        if (isToggle) {
            return (
                <div 
                    onClick={(e) => {
                        e.stopPropagation(); 
                        if (action) action();
                    }}
                    style={{
                        width: '40px',
                        height: '24px',
                        borderRadius: '12px',
                        backgroundColor: isToggled ? primaryColor : borderColor,
                        position: 'relative',
                        cursor: 'pointer',
                        transition: 'background-color 0.2s',
                        display: 'flex',
                        alignItems: 'center',
                        boxShadow: 'inset 0 1px 3px rgba(0,0,0,0.05)'
                    }}
                >
                    <div style={{
                        position: 'absolute',
                        top: '2px',
                        left: isToggled ? '18px' : '2px',
                        width: '20px',
                        height: '20px',
                        borderRadius: '50%',
                        backgroundColor: cardBackground,
                        transition: 'left 0.2s',
                        boxShadow: '0 1px 3px rgba(0,0,0,0.2)'
                    }} />
                </div>
            );
        }
        if (customContent) {
            return customContent;
        }
        return <FaChevronRight size={16} color={secondaryTextColor} />;
    };

    return (
        <div 
            onClick={action && !isToggle ? action : undefined} 
            style={{
                display: 'flex',
                alignItems: 'center',
                padding: '12px 0',
                cursor: action && !isToggle ? 'pointer' : (isToggle ? 'default' : 'default'), 
                borderBottom: isLast ? 'none' : `1px solid ${borderColor}`,
                transition: 'background-color 0.1s',
            }}
            onMouseOver={e => e.currentTarget.style.backgroundColor = action && !isToggle ? 'rgba(0, 0, 0, 0.03)' : cardBackground}
            onMouseOut={e => e.currentTarget.style.backgroundColor = cardBackground}
        >
            <Icon size={20} color={primaryColor} style={{ marginRight: '15px' }} />
            <div style={{ flexGrow: 1 }}>
                <p style={{ margin: 0, fontWeight: 'bold', color: textColor, fontSize: '15px' }}>{title}</p>
                {description && <p style={{ margin: 0, color: secondaryTextColor, fontSize: '12px', marginTop: '2px' }}>{description}</p>}
            </div>
            {renderAction()}
        </div>
    );
};


// Componente Principal da Tela Mais
export default function Mais() {
    // Cores fixas e primárias
    const PRIMARY_RED = '#B42222'; 
    const BORDER_COLOR = '#E0E0E0';
    const MAIN_TEXT_COLOR_REQUESTED = '#A6A6A6'; 

    // --- Lógica de Tema ---
    const [theme, setTheme] = useState('Claro'); 
    const [isNotificationToggled, setIsNotificationToggled] = useState(true);

    // Mapeamento de cores baseado no tema
    const themeStyles = {
        'Claro': {
            pageBackground: '#FFFFFF', 
            cardBackground: '#F6F6F6', 
            textColor: MAIN_TEXT_COLOR_REQUESTED, 
            secondaryTextColor: MAIN_TEXT_COLOR_REQUESTED, 
            borderColor: BORDER_COLOR,
        },
        'Escuro': {
            pageBackground: '#1C1C1E', 
            cardBackground: '#2C2C2E', 
            textColor: '#FFFFFF', 
            secondaryTextColor: '#B0B0B0', 
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


    // Função para alternar o tema
    const toggleTheme = useCallback(() => {
        setTheme(prevTheme => prevTheme === 'Claro' ? 'Escuro' : 'Claro');
    }, []);

    // Aplicar a cor de fundo da página ao body
    useEffect(() => {
        document.body.style.backgroundColor = pageBackground;
        return () => {
            document.body.style.backgroundColor = ''; 
        };
    }, [pageBackground]);

    // Componente de Informação do App (Versão)
    const AppInfoContent = (
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-end', lineHeight: 1.2 }}>
            <span style={{ color: textColor, fontWeight: 'bold', fontSize: '15px' }}>v1.0</span>
            <span style={{ color: secondaryTextColor, fontSize: '12px' }}>2025</span>
        </div>
    );

    return (
        <div className="mais-menu-page-container" style={{ 
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
            {/* Definição de variáveis CSS - Para garantir a fonte Inter */}
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
                    Mais
                </h1>
                <p style={{ color: secondaryTextColor, fontSize: '17px', margin: '5px 0 0', textAlign: 'left' }}>
                    Ajustes do aplicativo, ajuda e informações
                </p>
            </div>

            {/* CONTEÚDO PRINCIPAL COM PADDING HORIZONTAL */}
            <div style={{ padding: '0 15px', flexGrow: 1 }}>

                {/* 1. SEÇÃO DE CONFIGURAÇÕES DO APP (Transferida do Perfil) */}
                <h3 style={{ color: textColor, fontSize: '16px', margin: '20px 0 10px', textAlign: 'left' }}>Configurações</h3>
                <div style={{
                    backgroundColor: cardBackground, 
                    borderRadius: '12px',
                    padding: '0 20px',
                    marginBottom: '20px',
                    boxShadow: '0 2px 5px rgba(0, 0, 0, 0.05)',
                    transition: 'background-color 0.3s'
                }}>
                    <ConfigItem 
                        icon={FaSettingsPerson} 
                        title="Detalhes da conta" 
                        description="Gerencie nome, e-mail e senha" 
                        action={() => console.log('Abrir Detalhes da Conta')} 
                        primaryColor={PRIMARY_RED} cardBackground={cardBackground} textColor={textColor} secondaryTextColor={secondaryTextColor} borderColor={borderColor}
                    />
                    <ConfigItem 
                        icon={FaShield} 
                        title="Privacidade e segurança" 
                        description="Configurações de segurança e dados" 
                        action={() => console.log('Abrir Privacidade')} 
                        primaryColor={PRIMARY_RED} cardBackground={cardBackground} textColor={textColor} secondaryTextColor={secondaryTextColor} borderColor={borderColor}
                    />
                    <ConfigItem 
                        icon={FaBell} 
                        title="Notificações" 
                        description="Ligar/Desligar alertas do sistema" 
                        isToggle={true}
                        isToggled={isNotificationToggled}
                        action={() => setIsNotificationToggled(!isNotificationToggled)}
                        primaryColor={PRIMARY_RED} cardBackground={cardBackground} textColor={textColor} secondaryTextColor={secondaryTextColor} borderColor={borderColor}
                    />
                    <ConfigItem 
                        icon={FaTheme} 
                        title="Tema" 
                        description={`Tema atual: ${theme}`} 
                        isToggle={true}
                        isToggled={theme === 'Escuro'} 
                        action={toggleTheme}
                        primaryColor={PRIMARY_RED} cardBackground={cardBackground} textColor={textColor} secondaryTextColor={secondaryTextColor} borderColor={borderColor}
                    />
                    <ConfigItem 
                        icon={FaGlobe} 
                        title="Idioma" 
                        description="Português (Brasil)" 
                        action={() => console.log('Mudar Idioma')} 
                        isLast={true}
                        primaryColor={PRIMARY_RED} cardBackground={cardBackground} textColor={textColor} secondaryTextColor={secondaryTextColor} borderColor={borderColor}
                    />
                </div>

                {/* 2. SEÇÃO DE SUPORTE E INFORMAÇÕES LEGAIS */}
                <h3 style={{ color: textColor, fontSize: '16px', margin: '0 0 10px', textAlign: 'left' }}>Ajuda</h3>
                <div style={{
                    backgroundColor: cardBackground, 
                    borderRadius: '12px',
                    padding: '0 20px',
                    marginBottom: '20px',
                    boxShadow: '0 2px 5px rgba(0, 0, 0, 0.05)',
                    transition: 'background-color 0.3s'
                }}>
                    <ConfigItem 
                        icon={FaHelpCircle} 
                        title="Central de ajuda" 
                        description="Dúvidas frequentes e contato com suporte" 
                        action={() => console.log('Abrir Central de Ajuda')} 
                        primaryColor={PRIMARY_RED} cardBackground={cardBackground} textColor={textColor} secondaryTextColor={secondaryTextColor} borderColor={borderColor}
                    />
                    <ConfigItem 
                        icon={FaFileText} 
                        title="Termos de uso" 
                        description="Condições gerais de serviço" 
                        action={() => console.log('Abrir termos de uso')} 
                        primaryColor={PRIMARY_RED} cardBackground={cardBackground} textColor={textColor} secondaryTextColor={secondaryTextColor} borderColor={borderColor}
                    />
                    <ConfigItem 
                        icon={FaLock} 
                        title="Política de privacidade" 
                        description="Como seus dados são usados" 
                        action={() => console.log('Abrir Política de Privacidade')} 
                        isLast={true}
                        primaryColor={PRIMARY_RED} cardBackground={cardBackground} textColor={textColor} secondaryTextColor={secondaryTextColor} borderColor={borderColor}
                    />
                </div>
                
                {/* 3. INFORMAÇÕES SOBRE O APP */}
                <h3 style={{ color: textColor, fontSize: '16px', margin: '0 0 10px', textAlign: 'left' }}>Sobre</h3>
                <div style={{
                    backgroundColor: cardBackground, 
                    borderRadius: '12px',
                    padding: '0 20px',
                    marginBottom: '20px',
                    boxShadow: '0 2px 5px rgba(0, 0, 0, 0.05)',
                    transition: 'background-color 0.3s'
                }}>
                    <ConfigItem 
                        icon={FaAppInfo} 
                        title="Versão do aplicativo" 
                        description="Informações sobre Voltrix" 
                        primaryColor={PRIMARY_RED} cardBackground={cardBackground} textColor={textColor} secondaryTextColor={secondaryTextColor} borderColor={borderColor}
                        isLast={true}
                        customContent={AppInfoContent} 
                    />
                </div>
                
                {/* Rodapé */}
                <div style={{ textAlign: 'center', color: secondaryTextColor, fontSize: '12px', marginBottom: '20px', paddingBottom: '50px' }}>
                    <p style={{ margin: '5px 0' }}>© 2025 Voltrix. Todos os direitos reservados.</p>
                </div>
                
            </div>
        </div>
    );
}
