export default (editor, config = {}) => {
    editor.BlockManager.add('lesli-mailer-inky-callout', {
        label: 'Callout',
        category: 'Email',
        content: `
        <table class="callout">
            <tbody>
                <tr>
                    <th class="callout-inner success">
                        <p>Created a new folder. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
                    </th>
                    <th class="expander"></th>
                </tr>
            </tbody>
        </table>
        `
    })
}

