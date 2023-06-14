### 00.10. Core
```plaintext
00.00. accounts
00.01. roles
00.02. users
00.06. system_controllers
00.07. system_controller_actions
00.08. system_locations 

00.01. accounts (reference only)
00.10. account_settings
00.11. account_locations
00.12. account_activities
00.13. account_logs
00.14. account_files
00.15. account_currencies
00.16. account_currency_exchange_rates

00.03. user (reference only)
00.30. user_details
00.31. user_settings
00.32. user_sessions
00.33. user_requests
00.34. user_activities
00.35. user_roles
00.36. user_logs
00.37. user_codes
00.38. user_shortcuts
00.40. user_agents
00.41. user_tokens //-> new implementation for account integrations, this shares the session token

00.50. descriptors
00.51. descriptor_privileges
00.52. descriptor_activities

00.02. roles (reference only)
00.55. role_modulos
00.56. role_descriptor
00.57. role_activities
00.58. role_privileges

00.90. feedback
```
