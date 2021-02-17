
export default (editor, config = {}) => {
    editor.BlockManager.add('lesli-mailer-inky-button', {
        label: 'Button',
        category: 'Email',
        draggable: false,
        content: `
            <button>hola, soy un simple boton</button>
        `,
        content2: `
        <table class="button">
            <tbody>
                <tr>
                    <td>
                        <table>
                            <tbody>
                                <tr>
                                    <td><a href="#" contenteditable="true">Button exportable</a></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>
        `
    })
}
