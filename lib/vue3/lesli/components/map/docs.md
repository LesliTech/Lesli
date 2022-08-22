# Map

The component lesli-map is used to display a map made with apple mapkit.

## Props

**:locations**
prop that contains all the annotation that would be displayed in the map
- **type**: Array
- **required**: true
- **default**: [{ latitude: "", longitude:""}]

**:distanceView**
prop that indicates the distanceView of the map in meters
- **type**: Number
- **required**: false
- **default**: 240000 (240km)

## Example 
```html

<lesli-map
    :locations="[
        { latitude: "37.7951315", longitude: "-122.402986", title: "City Hall", color:"#c969e0"},
        { latitude: "37.7954201", longitude: "-122.39352", title: "Pyramid Tower"},
        { latitude: "37.8083396", longitude: "-122.415727", title: "Empire Building", url:"https://www.google.com/"}   
    ]"
    distanceView = 2500
>
</lesli-map>

```
