export default (editor, config = {}) => {
    editor.BlockManager.add('lesli-mailer-inky-button', {
        label: 'Button',
        category: 'Email',
        content: `
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
