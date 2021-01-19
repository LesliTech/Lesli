export default (editor, config = {}) => {
    editor.BlockManager.add('lesli-mailer-inky-wrapper', {
        label: 'Wrapper',
        category: 'Email',
        content: `
        <table class="wrapper" align="center">
            <tbody>
                <tr>
                    <td class="wrapper-inner">
                        content
                    </td>
                </tr>
            </tbody>
        </table>
        `
    })
}


