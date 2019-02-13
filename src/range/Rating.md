# Rating component
Easy to use rating web-component. As usual, it follows unidirection/one-way data flow pattern.

# API

## Properties
| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| `value` | float | 0.0 | The set value of the rating component. |
| `max` | int | 5 | Maximum number of stars. |
| `disabled` | boolean | true | Renders the greyed component |

## Events
| Event Name | Data | Type | Description |
| ---------- | ---- | ---- | ----------- |
| `change` | newValue | int | New value that user selected. |

# Style customization

| CSS Variable | Default | Description |
| ------------ | ------- | ----------- |
| `main-color` | `#F09300` | Fill and border colors for stars |
| `disabled-color` | `#888888` | Fill and border colors for disabled stars |
