// >>>>>>>>>>> PAGINA EM JSX

export default function Inputs(props){

    const type = props.type
    const placeholder = props.placeholder

    return(
        <div>
            <input type={type} placeholder={placeholder}/>
        </div>
    );
}