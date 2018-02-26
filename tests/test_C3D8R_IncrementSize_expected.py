parameters = {
    "results":
        [
            # More complicated case to find the slope of the stress strain curve within the interval 0.0001 < x < 0.005
            {
                "type": "slope",
                "step": "Step-1",                                   # By default the step is assumed to be the first step. Can specify any step with the step name
                "identifier": [                                     # The identifier here is an array since we are looking for the slope of a curve defined by x and y
                    { # x
                        "symbol": "LE11",
                        "elset": "ALL_ELEMS",
                        "position": "Element 1 Int Point 1"
                    },
                    { # y
                        "symbol": "S11",
                        "elset": "ALL_ELEMS",
                        "position": "Element 1 Int Point 1"
                    }
                ],
                "window": [0.0001, 0.02],                          # [min, max] in x        
                "referenceValue": 44800,                           # Reference value for E1
                "tolerance": 44.8                                   # Require that the calculated value is within 1% of the reference value
            }
        ]
}