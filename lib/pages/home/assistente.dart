// >>>>>>>>>>> PAGINA EM JSX

import React from 'react';

// NOVO Ícone de Envio (Estilo Gemini/Papel)
const SendIcon = ({ style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <path d="M22 2L11 13"></path>
        <path d="M22 2L15 22L11 13L2 9L22 2Z"></path>
    </svg>
);

// Ícone de Sugestão 1: Reduzir Consumo (Relâmpago)
const FaBolt = ({ style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon>
    </svg>
);

// Ícone de Sugestão 2: Status Dispositivos (Termômetro)
const FaThermometer = ({ style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <path d="M14 14.76V3.5a2.5 2.5 0 0 0-5 0v11.26a4.5 4.5 0 1 0 5 0z"></path>
    </svg>
);

// Ícone de Sugestão 3: Melhor Horário (Relógio)
const FaClock = ({ style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <circle cx="12" cy="12" r="10"></circle>
        <polyline points="12 6 12 12 16 14"></polyline>
    </svg>
);

// Ícone de Sugestão 4: Dicas Personalizadas (Lâmpada)
const FaLightbulb = ({ style = {} }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={style}>
        <path d="M9 18V5.5c0-.4.3-.8.8-.8h4.4c.4 0 .8.3.8.8V18"></path>
        <path d="M12 21a2 2 0 0 1-2-2h4a2 2 0 0 1-2 2z"></path>
        <path d="M12 21v2"></path>
    </svg>
);

// Componente principal da página do Assistente IA
export default function Assistente() {
    // Definindo as variáveis CSS
    const primaryColor = 'var(--cor-primaria)';
    const textColor = 'var(--cor-texto-claro)';
    const secondaryTextColor = 'var(--cor-texto-escuro)';
    
    // Cores baseadas nas definições do seu index.css
    const pageBackgroundColor = '#ffffff'; // Fundo principal deve ser branco
    const cardBackground = 'var(--cor-fundo-card)'; // Cards (Fundo do Card, é #f6f6f6 no seu index.css) 

    // Mensagens de chat simuladas
    const [messages, setMessages] = React.useState([
        { 
            id: 1, 
            text: "Olá! Sou a assistente da Voltrix. Como posso te ajudar a otimizar o consumo de energia hoje?", 
            sender: 'bot', 
            time: '16:03' 
        },
    ]);
    const [inputMessage, setInputMessage] = React.useState('');
    const chatEndRef = React.useRef(null); // Referência para o fim da área de chat
    const chatContainerRef = React.useRef(null); // REFERÊNCIA ADICIONADA PARA O CONTÊINER

    // Usado para corrigir o bug de rolagem ao digitar
    const messageCount = messages.length; 

    // EFEITO COMBINADO: Rola para o topo na montagem E para o fim em novas mensagens
    React.useEffect(() => {
        if (chatContainerRef.current) {
            if (messageCount <= 1) {
                // ROLAGEM INICIAL: FORÇA O SCROLL PARA O TOPO (0)
                chatContainerRef.current.scrollTop = 0;
            } else if (messageCount > 2 && chatEndRef.current) {
                // ROLAGEM CONTÍNUA: Rola apenas após a segunda mensagem (resposta do bot)
                chatEndRef.current.scrollIntoView({ behavior: 'smooth' });
            }
        }
    }, [messageCount]); // Depende apenas da contagem de mensagens

    // Função para simular o envio de mensagem
    const handleSendMessage = () => {
        if (inputMessage.trim() !== '') {
             const messageText = inputMessage;
            
            // Limpa o input antes de atualizar o messages
            setInputMessage(''); 

            const newMessage = {
                id: messages.length + 1,
                text: messageText,
                sender: 'user',
                time: new Date().toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' }),
            };
            setMessages(prevMessages => [...prevMessages, newMessage]);
            
            // Simulação de resposta do bot após 1 segundo
            setTimeout(() => {
                setMessages(prevMessages => [...prevMessages, {
                    id: prevMessages.length + 1,
                    text: "Essa é uma excelente pergunta! Vou processar a sua solicitação. (Esta será a área de resposta da IA)",
                    sender: 'bot',
                    time: new Date().toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' }),
                }]);
            }, 1000);
        }
    };

    // Função para enviar uma sugestão como mensagem do usuário
    const handleSendSuggestion = (suggestion) => {
        const newMessage = {
            id: messages.length + 1,
            text: suggestion,
            sender: 'user',
            time: new Date().toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' }),
        };
        
        // CORREÇÃO: Limpa o input (fazendo a sugestão fixa desaparecer) e
        // adiciona a mensagem do usuário na mesma renderização para garantir rolagem suave.
        setInputMessage(''); 
        setMessages(prevMessages => [...prevMessages, newMessage]);

           // Simulação de resposta do bot após 1 segundo
           setTimeout(() => {
               setMessages(prevMessages => [...prevMessages, {
                   id: prevMessages.length + 1,
                   text: "Entendido! Vamos analisar o seu pedido sobre " + suggestion.toLowerCase().replace('?', '.').replace('sugestões', 'sugestoes') + " (Resposta da IA à sugestão).",
                   sender: 'bot',
                   time: new Date().toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' }),
               }]);
           }, 1000);
    };

    // Componente individual da Mensagem (sem alterações)
    const Message = ({ text, sender, time }) => (
        <div 
            className={`message ${sender}`}
            style={{
                display: 'flex',
                justifyContent: sender === 'user' ? 'flex-end' : 'flex-start',
                marginBottom: '10px',
            }}
        >
            <div 
                style={{
                    maxWidth: '80%',
                    padding: '10px 15px',
                    borderRadius: '15px',
                    borderTopLeftRadius: sender === 'bot' ? '2px' : '15px',
                    borderTopRightRadius: sender === 'user' ? '2px' : '15px',
                    backgroundColor: sender === 'user' ? primaryColor : cardBackground,
                    color: sender === 'user' ? 'white' : textColor,
                    boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
                }}
            >
                <p style={{ margin: 0, lineHeight: '1.4' }}>{text}</p>
                <span style={{ 
                    display: 'block', 
                    fontSize: '10px', 
                    textAlign: sender === 'user' ? 'right' : 'left', 
                    color: sender === 'user' ? 'rgba(255, 255, 255, 0.7)' : secondaryTextColor,
                    marginTop: '5px' 
                }}>
                    {time}
                </span>
            </div>
        </div>
    );

    // Dados das sugestões
    const suggestions = [
        { icon: FaBolt, title: "Reduzir consumo", text: "Como posso economizar energia?", color: primaryColor, bgColor: cardBackground },
        { icon: FaThermometer, title: "Status dos dispositivos", text: "Quais dispositivos estão ligados?", color: primaryColor, bgColor: cardBackground },
        { icon: FaClock, title: "Melhor horário", text: "Quando usar mais energia?", color: primaryColor, bgColor: cardBackground },
        { icon: FaLightbulb, title: "Dicas personalizadas", text: "Sugestões para minha casa", color: primaryColor, bgColor: cardBackground },
    ];


    return (
        <div className="assistente-page-container" style={{ 
            display: 'flex', 
            flexDirection: 'column', 
            height: '100vh', 
            maxWidth: '450px',
            margin: '0 auto',
            // Adiciona padding na parte inferior para compensar o input fixo e a navbar
            paddingBottom: '130px', 
            backgroundColor: pageBackgroundColor
        }}>
            
            {/* --- ESTILO ISOLADO PARA PLACEHOLDER --- */}
            <style jsx="true">{`
                .input-area input::placeholder {
                    color: #a6a6a6 !important;
                    opacity: 1 !important;
                }
                .input-area input::-webkit-input-placeholder {
                    color: #a6a6a6 !important;
                }
                .input-area input::-moz-placeholder {
                    color: #a6a6a6 !important;
                }
            `}</style>
            
            {/* CABEÇALHO DA PÁGINA (Alinhado à esquerda e sem linha) */}
            <div className="page-header" style={{ padding: '20px 15px 15px', borderBottom: 'none', backgroundColor: pageBackgroundColor }}>
                <h1 style={{ color: primaryColor, fontSize: '28px', margin: '0', textAlign: 'left' }}>
                    Assistente Voltrix
                </h1>
                <p style={{ color: secondaryTextColor, fontSize: '17px', margin: '5px 0 0', textAlign: 'left' }}>
                    Sua consultora de energia inteligente
                </p>
            </div>
            
            {/* ÁREA DE CHAT (Scrollable) */}
            <div 
                className="chat-area" 
                ref={chatContainerRef} // REFERÊNCIA USADA AQUI PARA CONTROLE DO SCROLL INICIAL
                style={{ flexGrow: 1, overflowY: 'auto', padding: '0 15px', marginBottom: '15px' }}
            >
                {messages.map(msg => (
                    <Message key={msg.id} text={msg.text} sender={msg.sender} time={msg.time} />
                ))}
                <div ref={chatEndRef} /> {/* Referência para rolagem automática */}
            </div> 

            {/* --- SEÇÃO DE SUGESTÕES (FICA FIXA ACIMA DO INPUT) --- */}
            {/* Condicional: Só mostra sugestões se for a mensagem inicial (messageCount <= 1)
                e se o usuário NÃO estiver digitando (inputMessage.length === 0).
            */}
            {messageCount <= 1 && inputMessage.length === 0 && (
                <div 
                    className="suggestions-fixed-overlay"
                    style={{
                        position: 'fixed',
                        bottom: '130px', // Acima da área de input (75px) + navbar (60px) + 5px de margem
                        left: 0,
                        right: 0,
                        maxWidth: '450px',
                        margin: '0 auto',
                        padding: '0 15px 15px',
                        backgroundColor: pageBackgroundColor,
                        zIndex: 9
                    }}
                >
                    <h3 style={{ color: textColor, fontSize: '16px', margin: '0 0 10px', textAlign: 'left' }}>Sugestões:</h3>
                    <div className="suggestions-grid" style={{ 
                        display: 'grid', 
                        gridTemplateColumns: '1fr 1fr', 
                        gap: '10px', 
                        marginBottom: '0' 
                    }}>
                        {suggestions.map((s, index) => (
                            <div 
                                key={index}
                                onClick={() => handleSendSuggestion(s.text)}
                                style={{
                                    backgroundColor: cardBackground, 
                                    padding: '15px',
                                    borderRadius: '12px',
                                    cursor: 'pointer',
                                    transition: 'transform 0.2s, box-shadow 0.2s',
                                    boxShadow: '0 2px 5px rgba(0, 0, 0, 0.05)',
                                    border: 'none' 
                                }}
                                onMouseOver={e => e.currentTarget.style.transform = 'translateY(-2px)'}
                                onMouseOut={e => e.currentTarget.style.transform = 'translateY(0)'}
                            >
                                <s.icon style={{ color: primaryColor, marginBottom: '5px' }} />
                                <p style={{ color: textColor, fontWeight: 'bold', fontSize: '14px', margin: 0 }}>{s.title}</p>
                                <p style={{ color: secondaryTextColor, fontSize: '12px', margin: '3px 0 0' }}>{s.text}</p>
                            </div>
                        ))}
                    </div>
                </div>
            )}

            {/* INPUT DE MENSAGEM (Fixo na parte inferior) */}
            <div className="input-area" style={{ 
                padding: '10px 15px', 
                position: 'fixed', 
                // Subiu a área de input
                bottom: '75px', 
                left: 0, 
                right: 0, 
                backgroundColor: pageBackgroundColor, // Fundo da área de input branco
                zIndex: 10 
            }}>
                <div 
                    style={{ 
                        display: 'flex', 
                        alignItems: 'center', 
                        gap: '10px', 
                        maxWidth: '450px',
                        margin: '0 auto'
                    }}
                >
                    <input
                        type="text"
                        placeholder="Digite sua pergunta sobre energia..."
                        value={inputMessage}
                        onChange={(e) => setInputMessage(e.target.value)}
                        onKeyDown={(e) => e.key === 'Enter' && handleSendMessage()}
                        style={{
                            flexGrow: 1,
                            padding: '12px 15px',
                            borderRadius: '25px',
                            // --- BORDA REMOVIDA E SOMBRA ---
                            border: 'none',
                            boxShadow: '0 2px 5px rgba(0, 0, 0, 0.1)',
                            backgroundColor: 'white', 
                            // --- COR DO TEXTO DIGITADO: Cinza claro (#a6a6a6) ---
                            color: '#a6a6a6', 
                            fontSize: '16px',
                            outline: 'none',
                        }}
                    />
                    <button
                        onClick={handleSendMessage}
                        disabled={inputMessage.trim() === ''}
                        style={{
                            // Círculo com sombra e sem borda
                            backgroundColor: 'white', 
                            color: '#a6a6a6', 
                            padding: '12px', 
                            borderRadius: '50%',
                            border: 'none', 
                            boxShadow: '0 2px 5px rgba(0, 0, 0, 0.1)', 
                            cursor: inputMessage.trim() === '' ? 'not-allowed' : 'pointer',
                            opacity: inputMessage.trim() === '' ? 0.6 : 1,
                            transition: 'background-color 0.3s',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                        }}
                    >
                        {/* Usa o SendIcon com a cor do próprio botão */}
                        <SendIcon style={{ width: '24px', height: '24px' }} /> 
                    </button>
                </div>
            </div>
        </div>
    );
}
