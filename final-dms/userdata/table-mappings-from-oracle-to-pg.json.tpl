{
    "rules": [
        {
            "rule-type": "selection",
            "rule-id": "1",
            "rule-name": "1",
            "object-locator": {
                "schema-name": "SCOTT",
                "table-name": "%"
            },
            "rule-action": "include",
            "filters": []
        },
        {
            "rule-type": "transformation",
            "rule-id": "2",
            "rule-name": "2",
            "rule-target": "table",
            "object-locator": {
                "schema-name": "%",
                "table-name": "%"
            },
            "rule-action": "convert-lowercase",
            "value": null,
            "old-value": null
        },
        {
            "rule-type": "transformation",
            "rule-id": "3",
            "rule-name": "3",
            "rule-target": "column",
            "object-locator": {
                "schema-name": "%",
                "table-name": "%",
                "column-name": "%"
            },
            "rule-action": "convert-lowercase",
            "value": null,
            "old-value": null
        },
        {
            "rule-type": "transformation",
            "rule-id": "4",
            "rule-name": "4",
            "rule-action": "rename",
            "rule-target": "schema",
            "object-locator": {
                "schema-name": "SCOTT"
            },
            "value": "scott"
        }
    ]
}
