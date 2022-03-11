export default (editor, config = {}) => {
    editor.BlockManager.add('lesli-mailer-inky-spacer', {
        label: 'Spacer',
        category: 'Email',
        content: `
        <table class="spacer">
            <tbody>
                <tr>
                    <td height="100" style="font-size:100px;line-height:100px;">&nbsp;</td>
                </tr>
            </tbody>
        </table>
        `
    })
}

