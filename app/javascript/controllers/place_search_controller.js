import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['search', 'name', 'latitude', 'longitude']
    static values = { apiKey: String }

    connect() {
        this.searchRef = placeSearch({
            key: this.apiKeyValue,
            container: this.searchTarget,
            // useDeviceLocation: true
        });

        this.searchRef.on('change', (e) => {
            const { latlng: { lat, lng }, value } = e.result
            this.nameTarget.value = value;
            this.latitudeTarget.value = lat;
            this.longitudeTarget.value = lng;
        });

        if (this.nameTarget.value) {
            this.searchRef.setVal(this.nameTarget.value);
        }

        // TODO: IP
        //  - Connect this API result below back to a DOM element
        //    with a link to search by it
        //  - That link fetches from the FEE based service to get
        //    City, State, lat/lng
        //  - Populates those values in the form just lik MapQuest
        //  - Requires end user to click enter
        // fetch('https://api.ipify.org')
        //     .then((response) => response.text())
        //     .then((data) => console.log(data));

        // TODO: Geolocation
        //  - link to use current location
        //  - initiate lookup
        //  - require name (perhaps disconnect mapquest in this instance)
        // navigator.geolocation.getCurrentLocation(success, error, options)
    }

    disconnect() {
        this.searchRef.destroy();
    }
}
