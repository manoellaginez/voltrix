// >>>>>>>>>>> PAGINA EM JSX

import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';

// Ícones SVG Inline (Ajustados para o tema)
const FaArrowLeft = () => (
    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M19 12H5"></path>
        <path d="M12 19l-7-7 7-7"></path>
    </svg>
);
const FaClock = ({ style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <circle cx="12" cy="12" r="10"></circle>
        <polyline points="12 6 12 12 16 14"></polyline>
    </svg>
);
const FaBolt = ({ style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon>
    </svg>
);
const FaTarget = ({ style = {} }) => ( // Novo Ícone para Metas
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <circle cx="12" cy="12" r="10"></circle>
        <circle cx="12" cy="12" r="6"></circle>
        <circle cx="12" cy="12" r="2"></circle>
    </svg>
);


// Componente principal da página de Gerenciamento
export default function Gerenciar() {
    const navigate = useNavigate();
    const [isEconomyModeActive, setIsEconomyModeActive] = useState(false);
    const [shouldAutoRelink, setShouldAutoRelink] = useState(false);
    
    // NOVO ESTADO: Armazena o status de ativação/desativação de cada regra
    const [ruleStatuses, setRuleStatuses] = useState({
        ruleTarget: true,
        ruleClock: true,
        ruleBolt: false,
    });


    // Dados simulados (para evitar dependência do estado global de App.jsx neste componente)
    const availableDevices = [
        { id: 1, name: 'Lâmpada Sala' },
        { id: 2, name: 'Ar Cond. Quarto' },
        { id: 3, name: 'Chuveiro Elétrico' },
    ];
    
    // Cores baseadas nas suas variáveis CSS
    const primaryColor = 'var(--cor-primaria, #B42222)';
    const textColor = 'var(--cor-texto-claro, #333333)';
    const secondaryTextColor = 'var(--cor-texto-escuro, #a6a6a6)';
    const cardBackground = 'var(--cor-fundo-card, #f6f6f6)';
    const successColor = 'var(--cor-sucesso, #28a745)';

    const [selectedDevice, setSelectedDevice] = useState(availableDevices[0]?.id || null);
    const [actionTime, setActionTime] = useState('23:00');
    const [actionType, setActionType] = useState('Desligar');
    const [relinkTime, setRelinkTime] = useState('07:00'); // Novo estado para horário de retorno

    const handleSchedule = () => {
        const deviceName = availableDevices.find(d => d.id === parseInt(selectedDevice))?.name;
        
        let message = `Agendamento criado: ${actionType} ${deviceName} às ${actionTime}.`;
        if (shouldAutoRelink) {
            message += ` Ligar novamente às ${relinkTime}.`;
        } else if (actionType === 'Desligar') {
             message += ` O dispositivo permanecerá ${actionType} até ser ligado manualmente.`;
        }

        // Substituir alert() por um modal em produção
        alert(message);
    };

    // Função para alternar o status de uma regra
    const handleToggleRule = (ruleId) => {
        setRuleStatuses(prev => ({
            ...prev,
            [ruleId]: !prev[ruleId]
        }));
    };

    // Componente customizado de Toggle para Regras e Otimização
    const CustomToggle = ({ isActive, onClick, activeColor }) => (
        <div 
            className="device-toggle"
            style={{ 
                backgroundColor: isActive ? activeColor : 'var(--cor-borda)',
                width: '40px', 
                height: '20px', 
                borderRadius: '10px',
                position: 'relative',
                cursor: 'pointer',
                transition: 'background-color 0.3s',
                flexShrink: 0,
            }} 
            onClick={onClick}
        >
             <div 
                className="device-toggle-circle"
                style={{
                    position: 'absolute',
                    top: '2px',
                    left: isActive ? '22px' : '2px',
                    width: '16px',
                    height: '16px',
                    backgroundColor: 'white',
                    borderRadius: '50%',
                    boxShadow: '0 1px 3px rgba(0, 0, 0, 0.2)',
                    transition: 'transform 0.3s, left 0.3s'
                }}
            ></div>
        </div>
    );
    
    // Componente para estilizar os cards de Regra (RuleDetailCard)
    const RuleDetailCard = ({ icon: Icon, title, description, iconColor, ruleId, handleToggleRule, isActive }) => {
        const currentIconColor = isActive ? iconColor : secondaryTextColor;

        return (
            <div 
                style={{
                    padding: '15px',
                    borderRadius: '12px',
                    backgroundColor: cardBackground, 
                    boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
                    marginBottom: '15px',
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'flex-start',
                    border: 'none',
                    fontFamily: 'Inter, sans-serif'
                }}
            >
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', width: '100%', marginBottom: '10px' }}>
                    <div style={{ display: 'flex', alignItems: 'center' }}>
                        <Icon style={{ color: currentIconColor, marginRight: '15px', marginTop: '3px', fontSize: '22px', flexShrink: 0 }} />
                        <h3 style={{ color: textColor, margin: 0, fontSize: '16px', fontWeight: 'bold' }}>{title}</h3>
                    </div>
                    
                    {/* TOGGLE PARA ATIVAR/DESATIVAR A REGRA INDIVIDUAL */}
                    <CustomToggle 
                        isActive={isActive} 
                        onClick={() => handleToggleRule(ruleId)} 
                        activeColor={primaryColor} 
                    />
                </div>
                
                <p style={{ color: secondaryTextColor, margin: '5px 0 0 0', fontSize: '13px', lineHeight: '1.4' }}>{description}</p>
            </div>
        );
    };

    return (
        <div className="device-list-container" style={{ padding: '0 15px', paddingBottom: '80px', fontFamily: 'Inter, sans-serif' }}>
            
            {/* BOTÃO DE VOLTAR */}
            <div style={{ display: 'flex', justifyContent: 'flex-start', alignItems: 'center', paddingTop: '20px', marginBottom: '15px' }}>
                <button 
                    onClick={() => navigate(-1)} 
                    style={{ background: 'none', border: 'none', color: textColor, fontSize: '20px', cursor: 'pointer', padding: '0', marginRight: '10px', fontFamily: 'Inter, sans-serif' }}
                >
                    <FaArrowLeft />
                </button>
            </div>

            {/* TÍTULO PRINCIPAL */}
            <h1 style={{ color: primaryColor, fontSize: '28px', fontWeight: 'bold', margin: '0 0 5px', fontFamily: 'Inter, sans-serif' }}>
                Gerenciamento inteligente
            </h1>
            <p style={{ color: secondaryTextColor, fontSize: '17px', marginBottom: '30px', fontFamily: 'Inter, sans-serif' }}>
                Programe rotinas e ative o modo de otimização de gastos
            </p>

            {/* --- SEÇÃO 1: MODO DE ECONOMIA ATIVA (Toggle) --- */}
            <div 
                style={{
                    padding: '15px',
                    borderRadius: '12px',
                    backgroundColor: cardBackground,
                    boxShadow: '0 4px 8px rgba(0, 0, 0, 0.05)',
                    marginBottom: '25px',
                    border: 'none',
                }}
            >
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' /* REMOVIDA MARGIN E PADDING BOTTOM AQUI */ }}>
                    <h2 style={{ color: primaryColor, margin: 0, fontSize: '20px', fontFamily: 'Inter, sans-serif' }}>Modo de otimização ativa</h2>
                    {/* Toggle Switch */}
                    <CustomToggle 
                        isActive={isEconomyModeActive} 
                        onClick={() => setIsEconomyModeActive(!isEconomyModeActive)} 
                        activeColor={primaryColor} // CORRIGIDO: Usando primaryColor para o toggle
                    />
                </div>

                {/* CORREÇÃO FINAL: Removed a div externa e a margem do parágrafo */}
                <p style={{ color: textColor, margin: '5px 0 0 0', fontSize: '14px', lineHeight: '1.4', fontFamily: 'Inter, sans-serif' }}>
                    Este modo monitora o consumo em tempo real, se seus gastos estiverem significativamente elevados e excederem a projeção da sua meta, enviaremos sugestões proativas de desligamento para reverter a tendência
                    <br/>
                    <span style={{ color: isEconomyModeActive ? primaryColor : secondaryTextColor, fontWeight: 'bold' }}>
                        Status: {isEconomyModeActive ? 'ativo' : 'desativado'}
                    </span>
                </p>
            </div>
            
            {/* --- SEÇÃO 2: AGENDAMENTO MANUAL --- */}
            <h2 style={{ color: textColor, fontSize: '20px', fontWeight: 'bold', marginBottom: '15px', fontFamily: 'Inter, sans-serif' }}>
                Agendar rotina de desligamento
            </h2>
            
            <div style={{ padding: '20px', borderRadius: '12px', backgroundColor: cardBackground, boxShadow: '0 4px 8px rgba(0, 0, 0, 0.05)', marginBottom: '30px', fontFamily: 'Inter, sans-serif' }}>
                
                {/* SELEÇÃO DE DISPOSITIVO */}
                <div style={{ marginBottom: '15px' }}>
                    <label style={{ display: 'block', color: secondaryTextColor, marginBottom: '5px', fontSize: '14px', fontFamily: 'Inter, sans-serif' }}>Selecione o dispositivo:</label>
                    <select
                        value={selectedDevice || ''}
                        onChange={(e) => setSelectedDevice(e.target.value)}
                        style={inputStyle}
                    >
                        {availableDevices.map(d => (
                            <option key={d.id} value={d.id}>{d.name}</option>
                        ))}
                    </select>
                </div>

                {/* AÇÃO E HORÁRIO */}
                <div style={{ display: 'flex', gap: '10px', marginBottom: '20px' }}>
                    <div style={{ flex: 1 }}>
                        <label style={{ display: 'block', color: secondaryTextColor, marginBottom: '5px', fontSize: '14px', fontFamily: 'Inter, sans-serif' }}>Ação:</label>
                        <select
                            value={actionType}
                            onChange={(e) => setActionType(e.target.value)}
                            style={inputStyle}
                        >
                            <option value="Desligar">Desligar</option>
                            <option value="Ligar">Ligar</option>
                        </select>
                    </div>
                    <div style={{ flex: 1 }}>
                        <label style={{ display: 'block', color: secondaryTextColor, marginBottom: '5px', fontSize: '14px', fontFamily: 'Inter, sans-serif' }}>Horário:</label>
                        <input
                            type="time"
                            value={actionTime}
                            onChange={(e) => setActionTime(e.target.value)}
                            style={inputStyle}
                        />
                    </div>
                </div>

                {/* NOVO: OPÇÃO DE LIGAR NOVAMENTE */}
                {actionType === 'Desligar' && (
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', borderTop: '1px solid var(--cor-borda)', paddingTop: '15px', marginBottom: '25px' }}>
                         <p style={{ fontWeight: 'bold', margin: 0, fontSize: '16px', color: textColor, fontFamily: 'Inter, sans-serif' }}>
                            Ligar novamente?
                        </p>
                        {/* Toggle Switch para Ligar Novamente */}
                        <CustomToggle 
                            isActive={shouldAutoRelink} 
                            onClick={() => setShouldAutoRelink(!shouldAutoRelink)} 
                            activeColor={primaryColor} // CORRIGIDO: Usando primaryColor para o toggle
                        />
                    </div>
                )}

                {/* NOVO: CAMPO DE HORA DE RETORNO (Só se o toggle estiver ativo) */}
                {shouldAutoRelink && actionType === 'Desligar' && (
                    <div style={{ marginBottom: '25px' }}>
                        <label style={{ display: 'block', color: secondaryTextColor, marginBottom: '5px', fontSize: '14px', fontFamily: 'Inter, sans-serif' }}>Horário para ligar novamente:</label>
                         <input
                            type="time"
                            value={relinkTime}
                            onChange={(e) => setRelinkTime(e.target.value)}
                            style={inputStyle}
                        />
                    </div>
                )}


                <button 
                    onClick={handleSchedule}
                    style={{
                        backgroundColor: primaryColor,
                        color: 'white',
                        padding: '10px 15px',
                        borderRadius: '8px',
                        fontWeight: 'bold',
                        border: 'none',
                        width: '100%',
                        transition: 'background-color 0.3s',
                        fontFamily: 'Inter, sans-serif'
                    }}
                >
                    AGENDAR ROTINA
                </button>
            </div>


            {/* --- SEÇÃO 3: SUGESTÕES INTELIGENTES (Metas e Regras de Consumo) --- */}
            <h2 style={{ color: textColor, fontSize: '20px', fontWeight: 'bold', marginBottom: '15px', fontFamily: 'Inter, sans-serif' }}>
                Otimização ativa
            </h2>
            
            {/* Regra 3: Desligamento Baseado em Metas e Orçamento */}
            <RuleDetailCard 
                icon={FaTarget}
                title="Otimização por metas de orçamento"
                description="O sistema monitora a projeção de gastos. Se você exceder a meta definida, o app sugere o desligamento de dispositivos de alto consumo (como aquecedores) para reverter a tendência e manter seu orçamento"
                iconColor={primaryColor}
                ruleId="ruleTarget"
                handleToggleRule={handleToggleRule}
                isActive={ruleStatuses.ruleTarget}
            />

            {/* Regra 1: Esqueci ligado (Inatividade) */}
            <RuleDetailCard 
                icon={FaClock}
                title="Regra de inatividade"
                description="Se o consumo do aparelho (ex: Televisão) for mantido em modo stand-by (abaixo de 5 Watts) por mais de 3 horas durante a noite (23:00h - 07:00h), o app envia um alerta sugerindo o desligamento"
                iconColor={primaryColor}
                ruleId="ruleClock"
                handleToggleRule={handleToggleRule}
                isActive={ruleStatuses.ruleClock}
            />
            
            {/* Regra 2: Consumo Zumbi (Baixo Constante) */}
            <RuleDetailCard 
                icon={FaBolt}
                title="Regra de consumo fantasma"
                description="Se o dispositivo estiver consumindo menos de 1 Watt por mais de 8 horas seguidas (indicando carregamento completo ou inatividade), a tomada desliga automaticamente para eliminar o consumo passivo"
                iconColor={primaryColor}
                ruleId="ruleBolt"
                handleToggleRule={handleToggleRule}
                isActive={ruleStatuses.ruleBolt}
            />


            {/* --- SEÇÃO 4: VISÃO GERAL MELHORADA --- */}
            <div 
                style={{ 
                    marginTop: '30px', 
                    padding: '15px', 
                    borderRadius: '12px', 
                    backgroundColor: cardBackground, 
                    boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
                    fontFamily: 'Inter, sans-serif'
                }}
            >
                <h3 style={{ color: primaryColor, margin: '0 0 10px 0', fontSize: '18px', fontWeight: 'bold' }}>
                    Status das regras ativas
                </h3>
                <p style={{ color: textColor, margin: '0 0 5px 0', fontSize: '14px' }}>
                    <span style={{ fontWeight: 'bold', color: successColor }}>{Object.values(ruleStatuses).filter(status => status).length}/3 regras ativas</span>
                </p>
                <p style={{ color: textColor, margin: '0 0 5px 0', fontSize: '14px' }}>
                    <span style={{ fontWeight: 'bold', color: primaryColor }}>Modo de otimização: {isEconomyModeActive ? 'ativo' : 'desativado'}</span>
                </p>
                <p style={{ color: textColor, margin: 0, fontSize: '14px' }}>
                    <span style={{ fontWeight: 'bold', color: secondaryTextColor }}>Próxima ação: nenhuma rotina agendada</span>
                </p>
            </div>
            
        </div>
    );
}

// Componente para estilizar os cards de Regra (RuleDetailCard)
const RuleDetailCard = ({ icon: Icon, title, description, iconColor, ruleId, handleToggleRule, isActive }) => (
    <div 
        style={{
            padding: '15px',
            borderRadius: '12px',
            backgroundColor: cardBackground, 
            boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
            marginBottom: '15px',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'flex-start',
            border: 'none',
            fontFamily: 'Inter, sans-serif'
        }}
    >
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', width: '100%' }}>
            {/* ÍCONE E TÍTULO */}
            <div style={{ display: 'flex', alignItems: 'center', flex: 1 }}>
                <Icon style={{ color: isActive ? iconColor : 'var(--cor-texto-escuro)', marginRight: '15px', marginTop: '3px', fontSize: '22px', flexShrink: 0 }} />
                <h3 style={{ color: textColor, margin: 0, fontSize: '16px', fontWeight: 'bold' }}>{title}</h3>
            </div>

            {/* TOGGLE PARA ATIVAR/DESATIVAR A REGRA INDIVIDUAL */}
            <CustomToggle 
                isActive={isActive} 
                onClick={() => handleToggleRule(ruleId)} 
                activeColor={primaryColor} // Usando o vermelho primário
            />
        </div>

        <p style={{ color: secondaryTextColor, margin: '5px 0 0 0', fontSize: '13px', lineHeight: '1.4' }}>{description}</p>
    </div>
);


// Componente Customizado de Toggle (para Reutilização)
const CustomToggle = ({ isActive, onClick, activeColor }) => (
    <div 
        className="device-toggle"
        style={{ 
            backgroundColor: isActive ? activeColor : 'var(--cor-borda)',
            width: '40px', 
            height: '20px', 
            borderRadius: '10px',
            position: 'relative',
            cursor: 'pointer',
            transition: 'background-color 0.3s',
            flexShrink: 0,
        }} 
        onClick={onClick}
    >
         <div 
            className="device-toggle-circle"
            style={{
                position: 'absolute',
                top: '2px',
                left: isActive ? '22px' : '2px',
                width: '16px',
                height: '16px',
                backgroundColor: 'white',
                borderRadius: '50%',
                boxShadow: '0 1px 3px rgba(0, 0, 0, 0.2)',
                transition: 'transform 0.3s, left 0.3s'
            }}
        ></div>
    </div>
);


// Estilo customizado para inputs e selects
const inputStyle = {
    width: '100%',
    padding: '10px',
    borderRadius: '8px',
    border: '1px solid var(--cor-borda)',
    backgroundColor: 'white',
    color: 'var(--cor-texto-claro)',
    fontSize: '16px',
    boxSizing: 'border-box',
    outline: 'none',
    fontFamily: 'Inter, sans-serif',
};
