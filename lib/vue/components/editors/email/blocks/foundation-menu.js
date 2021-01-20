export default (editor, config = {}) => {
    editor.BlockManager.add('lesli-mailer-inky-menu', {
        label: 'Menu',
        category: 'Email',
        content: `
        <table class="menu">
            <tbody>
                <tr>
                    <td>
                        <table>
                            <tbody>
                                <tr>
                                    <th class="menu-item"><a href="https://zurb.com">Item</a></th>
                                    <th class="menu-item"><a href="https://zurb.com">Item</a></th>
                                    <th class="menu-item"><a href="https://zurb.com">Item</a></th>
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
