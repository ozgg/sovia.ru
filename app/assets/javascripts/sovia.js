"use strict";

/**
 * Sovia front-end features
 *
 * @type {Object}
 */
const Sovia = {
    initialized: false,
    components: {},
    autoInitComponents: true
};

/**
 * Enqueue list of pending patterns
 *
 * @type {Object}
 */
Sovia.components.pendingPatternEnqueue = {
    initialized: false,
    selector: ".js-pattern-queue-container",
    container: undefined,
    textarea: undefined,
    button: undefined,
    init: function () {
        this.container = document.querySelector(this.selector);
        if (this.container) {
            this.initialized = true;
            this.textarea = this.container.querySelector("textarea");
            this.button = this.container.querySelector("button");
            const component = this;
            this.button.addEventListener("click", component.handler);
        }
    },
    handler: function () {
        const component = Sovia.components.pendingPatternEnqueue;
        const url = component.container.getAttribute("data-url");
        const request = Biovision.jsonAjaxRequest("post", url, function () {
            component.textarea.value = "";
            component.button.disabled = false;
        }, Biovision.handleAjaxFailure);
        component.button.disabled = true;
        request.send(JSON.stringify({list: component.textarea.value}));
    }
};

/**
 * Quickly resolve pending pattern with summary
 *
 * @type {Object}
 */
Sovia.components.pendingPatternSummary = {
    initialized: false,
    selector: ".js-pending-pattern-summary",
    items: [],
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    apply: (element) => {
        const component = Sovia.components.pendingPatternSummary;
        component.items.push(element);
        element.addEventListener("change", component.handler);
    },
    handler: function (event) {
        const input = event.target;
        if (input.value.length > 0) {
            const state = input.parentNode.querySelector(".state");
            const url = input.getAttribute("data-url");
            const request = Biovision.jsonAjaxRequest("post", url, function () {
                const response = JSON.parse(this.responseText);
                if (response.hasOwnProperty("meta")) {
                    if (response.meta["processed"]) {
                        const container = input.closest(".info");
                        if (container) {
                            container.innerHTML = input.value;
                        }
                    }
                }
            }, function () {
                state.classList.remove("processing");
                state.classList.add("failed");
            });
            input.readonly = true;

            if (!state.classList.contains("processing")) {
                state.classList.add("processing");
                request.send(JSON.stringify({summary: input.value}));
            }
        }
    }
};

Sovia.components.interpretationRequests = {
    initialized: false,
    selector: "dream_interpretation_request_container",
    container: undefined,
    result: undefined,
    /**
     * @type {HTMLButtonElement}
     */
    button: undefined,
    init: function () {
        this.container = document.getElementById(this.selector);
        if (this.container) {
            this.result = this.container.querySelector(".result");
            this.button = this.container.querySelector("button");
            this.button.addEventListener("click", this.handler);
            this.initialized = true;
        }
    },
    handler: function () {
        const component = Sovia.components.interpretationRequests;
        const url = component.button.getAttribute("data-url");
        const request = Biovision.jsonAjaxRequest("post", url, component.processResponse);
        const data = {"dream_id": component.button.getAttribute("data-dream-id")};
        component.button.disabled = true;
        request.send(JSON.stringify(data));
    },
    processResponse: function () {
        const component = Sovia.components.interpretationRequests;
        const response = JSON.parse(this.responseText);
        if (response.hasOwnProperty("meta")) {
            component.result.innerHTML = response["meta"]["result"];
        }
        component.button.remove();
    }
};

Sovia.components.interpretationMessage = {
    initialized: false,
    selector: "new-interpretation-message-container",
    container: undefined,
    /**
     * @type [HTMLTextAreaElement]
     */
    field: undefined,
    /**
     * @type [HTMLButtonElement]
     */
    button: undefined,
    result: undefined,
    url: undefined,
    init: function () {
        this.container = document.getElementById(this.selector);
        if (this.container) {
            this.url = this.container.getAttribute("data-url");
            this.field = this.container.querySelector("textarea");
            this.button = this.container.querySelector("button");
            this.result = this.container.querySelector(".result");
            this.field.addEventListener("keyup", this.keyup);
            this.button.addEventListener("click", this.send);
            this.initialized = true;
        }
    },
    keyup: function () {
        const component = Sovia.components.interpretationMessage;
        const message = component.field.value.trim();
        component.button.disabled = message.length < 1;
        component.result.innerHTML = "";
    },
    send: function () {
        const component = Sovia.components.interpretationMessage;
        const request = Biovision.jsonAjaxRequest("post", component.url, component.processResponse, null);
        const data = {
            "interpretation_message": {
                "body": component.field.value
            }
        };

        component.button.disabled = true;
        request.send(JSON.stringify(data));
    },
    processResponse: function () {
        const response = JSON.parse(this.responseText);
        if (response.hasOwnProperty("meta")) {
            const component = Sovia.components.interpretationMessage;
            component.result.innerHTML = response["meta"]["result"];
            if (response["meta"]["ok"]) {
                component.field.value = "";
            }
        }
    }
};

Sovia.components.paypalButtons = {
    initialized: false,
    selector: ".buy-button .paypal",
    buttons: [],
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    apply: function (element) {
        const component = Sovia.components.paypalButtons;
        component.buttons.push(element);
        element.addEventListener("click", component.handler);
    },
    handler: function (event) {
        event.preventDefault();
        const component = Sovia.components.paypalButtons;
        const button = event.target;
        const url = button.getAttribute("href");
        const request = Biovision.jsonAjaxRequest("post", url, component.processResponse, component.processFailure);
        button.classList.add("processing");
        request.send();
    },
    processResponse: function () {
        const response = JSON.parse(this.responseText);
        let nextLink = false;
        if (response.hasOwnProperty("links")) {
            const links = response.links;
            if (links.hasOwnProperty("next")) {
                nextLink = true;
                document.location.href = links.next;
            }
        }
        if (!nextLink) {
            Sovia.components.paypalButtons.processFailure();
        }
    },
    processFailure: function () {
        const component = Sovia.components.paypalButtons;
        component.buttons.forEach(function (button) {
            button.classList.remove("processing");
        });
    }
};

Sovia.components.robokassaButtons = {
    initialized: false,
    selector: ".buy-button .robokassa",
    buttons: [],
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    apply: function (element) {
        const component = Sovia.components.robokassaButtons;
        component.buttons.push(element);
        element.addEventListener("click", component.handler);
    },
    handler: function (event) {
        event.preventDefault();
        const component = Sovia.components.robokassaButtons;
        const button = event.target;
        const url = button.getAttribute("href");
        const request = Biovision.jsonAjaxRequest("post", url, component.processResponse, component.processFailure);
        button.classList.add("processing");
        request.send();
    },
    processResponse: function () {
        const response = JSON.parse(this.responseText);
        if (response.hasOwnProperty("meta")) {
            const data = response.meta.robokassa;
            const fields = [
                ["IsTest", data["is_test"]],
                ["MerchantLogin", data["login"]],
                ["OutSum", data["out_sum"]],
                ["InvId", data["inv_id"]],
                ["SignatureValue", data["signature"]]
            ];

            const form = document.createElement("form");
            form.action = "https://merchant.roboxchange.com/Index.aspx";
            form.setAttribute("method", "post");
            fields.forEach(function (pair) {
                const input = document.createElement("input");
                input.setAttribute("type", "hidden");
                input.setAttribute("name", pair[0]);
                input.value = pair[1];
                form.append(input);
            });
            console.log(form);
            // document.querySelector("body").append(form);
            form.submit();
        } else {
            Sovia.components.robokassaButtons.processFailure();
        }
    },
    processFailure: function () {
        const component = Sovia.components.robokassaButtons;
        component.buttons.forEach(function (button) {
            button.classList.remove("processing");
        });
    }
};

Biovision.components.dreambook = Sovia;
