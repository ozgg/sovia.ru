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

Biovision.components.dreambook = Sovia;
