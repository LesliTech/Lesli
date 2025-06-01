---
title: Lesli Core Documentation
layout: website
---

<%
links = [{
    href: "/engines/lesli/about/",
    icon: "ri-heart-line",
    text: "About"
}, {
    href: "/engines/lesli/getting-started/",
    icon: "ri-send-plane-line",
    text: "Getting started"
}, {
    href: "/engines/lesli/contributing/",
    icon: "ri-git-pull-request-line",
    text: "Contributing"
}, {
    href: "/engines/lesli/database/",
    icon: "ri-database-line",
    text: "Database"
}, {
    href: "/engines/lesli/ruby-on-rails/",
    icon: "ri-server-line",
    text: "Ruby on Rails"
}, {
    href: "/engines/lesli/theming/",
    icon: "ri-window-line",
    text: "Frontend"
}, {
    href: "/engines/lesli/theming/",
    icon: "ri-palette-line",
    text: "Theming"
#}, {
#href: "/engines/lesli/security/",
#icon: "ri-shield-line",
#text: "Security"
}, {
    href: "/engines/lesli/generators/",
    icon: "ri-code-line",
    text: "Generators"
}, {
    href: "/engines/lesli/testing/",
    icon: "ri-bug-line",
    text: "Testing"
#}, {
#href: "/engines/lesli/engines/",
#icon: "ri-shapes-line",
#text: "Engines"
}, {
    href: "/engines/lesli/deployment/",
    icon: "ri-flashlight-line",
    text: "Deployment"
}]
%>

<div class="documentation-header">
    <img alt="Lesli Admin logo" src="../app/assets/images/lesli_admin/admin-logo.svg" />
    <h1>
        Administration area
    </h1>
</div>

<header>
    <%#= partial("partials/lesli-navigation", :locals => { :logo => true }) %>
    <div class="container">
        <%= image_tag "brand/lesli.svg", alt: "Lesli logo", class: "lesli-logo" %>
        <h1>Core <span class="lesli-title-colored">Documentation</span></h1>
        <p>Lesli is a SaaS development framework designed to build highly scalable, secure and customizable software products.</p>
    </div>
    <div class="container lesli-component-boxes">
        <div class="columns">
            <% links.each do |link| %>
                <div class="column">
                    <a href="<%= link[:href] %>">
                        <i class="<%= link[:icon] %>"></i>
                        <%= link[:text] %>
                    </a>
                </div>
            <% end %>
        </div>
    </div>
</header>
