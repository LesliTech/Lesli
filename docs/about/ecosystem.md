# Lesli Ecosystem

Lesli is designed to be **modular**. It uses standard **Ruby on Rails engines** (we call them modules) to extend and customize functionality, making it easy to build powerful, tailored applications on top of the Lesli framework.

The Lesli team maintains several **production-ready engines**, most of which are open source. These modules cover a wide range of common use cases and can be seamlessly integrated into your application to accelerate development.


<br/>

## 📂 Collections

A **Collection** is a group of modules organized by category or business industry. Collections help you quickly identify modules relevant to specific areas of your SaaS application.

### Available Collections:

1. **Administration**  
2. **Sales & Marketing**  
3. **Productivity & Teamwork**  
4. **Finance**  
5. **Analytics**  
6. **Intelligence**  
7. **IT & Help Desk**  
8. **Security & Privacy**  
9. **Integrations**


<br/>

## 🧩 Modules

Currently, we have **45 modules planned** for development. Out of these, **9 modules are fully developed and production-ready.**

| Code  | Module        | Description                                        |
|-------|---------------|----------------------------------------------------|
| 0101  | **LesliAdmin**   | Lesli administration area                        |
| 0301  | **LesliCalendar** | Unified calendar app                            |
| 0305  | **LesliLetter**   | Notes & notebooks                                |
| 0306  | **LesliDashboard**| Smart business assistant                        |
| 0308  | **LesliBell**     | Notification system                              |
| 0502  | **LesliAudit**    | System analytics                                 |
| 0702  | **LesliSupport**  | Support ticket system                            |
| 0801  | **LesliShield**   | Authentication & authorization module for Lesli  |
| 0901  | **LesliBabel**    | Translation management                           |

> You can also create your own custom modules. We will cover this process later in the documentation.

## 📊 Lesli Ecosystem Diagram (Overview)

```
+--------------------------------------------------+
|                     Lesli                        |
|        (Core Gem: Utilities, Generators)         |
+--------------------------------------------------+
                     /       \
                    /         \
         +----------------+  +------------------+
         |Official Modules|  |   Your Modules   |
         | (Rails Engines)|  | (Custom Engines) |
         +----------------+  +------------------+
                   |                    |
                   |                    |
     +-------------------------------------------+
     |         Integrated via Rails Engine       |
     +-------------------------------------------+
                   |
        +----------------------------+
        |Your SaaS Application (Host)|
        +----------------------------+
                   |
          +------------------+
          |  PostgreSQL / DB |
          +------------------+

```
