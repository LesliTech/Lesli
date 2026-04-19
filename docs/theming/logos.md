# Lesli Logos & images

<div class="columns lesli-css-color-logos">
    <div class="br-2 pl-6 pb-5 has-background-grey-lighter">
        <h4>Use the standard logo on light backgrounds.</h4>
        <img width="200" alt="Lesli Framework logo blue" src="/images/brand/lesli.svg" />
    </div>
    <div class="br-2 pl-6 pb-5 has-background-grey-darker">
        <h4 class="has-text-white">Use the negative logo on dark or saturated backgrounds.</h4>
        <img width="200" alt="Lesli Framework logo white" src="/images/brand/lesli-white.svg" />
    </div>
</div>

## Icons

Use the icon when horizontal space is limited, in app navigation, favicons, and compact UI contexts.

<div class="columns lesli-css-color-logos">
    <div class="br-2 pl-6 pb-5  has-background-grey-lighter">
        <h4>Use the standard icon on light backgrounds.</h4>
        <img width="180" class="m-auto display-block" alt="Lesli Framework logo blue" src="/images/brand/lesli-icon.svg" />
    </div>
    <div class="br-2 pl-6 pb-5  has-background-grey-darker">
        <h4 class="has-text-white">Use the negative icon on dark backgrounds.</h4>
        <img width="180" class="m-auto display-block" alt="Lesli Framework logo white" src="/images/brand/lesli-icon-white.svg" />
    </div>
</div>

## Logo usage rules

* Prefer the standard logo on white or neutral backgrounds.
* Prefer the negative logo on dark sections or image overlays.
* Do not stretch, rotate, outline, or recolor the logo.
* Do not apply gradients, shadows, or effects to the logo.
* Maintain generous clear space around the logo.
* Use the icon only when the full wordmark is not necessary.

## Logo customization 

Customizing the logo with Lesli is straightforward. In your main Rails app, create a folder at `ROR/assets/images/lesli/brand`. Lesli will look for this folder and replace the default Lesli logos with your custom branding logos.

You can override all the logo branding within your app by adding the following files:

```text
app-auth.svg -> Replaces the image at the top of the authentication forms.
app-icon.svg -> Default logo for mobile devices.
app-logo.svg -> Main image used for the header, emails, etc.
login-background.jpg -> Replaces to background image on the login page.
```
