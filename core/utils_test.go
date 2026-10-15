package core

import (
	"testing"
)

func TestPMetadata(t *testing.T) {
	cases := []struct {
		description string
		input       map[string]string
		expected    map[string]string
	}{
		// Positive: values survive and keys are lowercased.
		{
			description: "positive: lowercase key keeps its value",
			input:       map[string]string{"owner": "alice"},
			expected:    map[string]string{"owner": "alice"},
		},
		{
			description: "positive: mixed-case key is lowercased and keeps its value",
			input:       map[string]string{"Content-Owner": "alice"},
			expected:    map[string]string{"content-owner": "alice"},
		},
		{
			description: "positive: uppercase key is lowercased and keeps its value",
			input:       map[string]string{"OWNER": "alice"},
			expected:    map[string]string{"owner": "alice"},
		},
		// Negative: nothing to convert.
		{
			description: "negative: nil map gives an empty map",
			input:       nil,
			expected:    map[string]string{},
		},
		{
			description: "negative: empty map gives an empty map",
			input:       map[string]string{},
			expected:    map[string]string{},
		},
		// Boundary: empty keys and values.
		{
			description: "boundary: empty value on a mixed-case key stays empty",
			input:       map[string]string{"Owner": ""},
			expected:    map[string]string{"owner": ""},
		},
		{
			description: "boundary: empty key keeps its value",
			input:       map[string]string{"": "alice"},
			expected:    map[string]string{"": "alice"},
		},
		// Corner: several keys, non-ASCII, and keys that only differ from
		// another entry's lowercased form.
		{
			description: "corner: several mixed-case keys each keep their own value",
			input:       map[string]string{"A": "1", "bB": "2", "c": "3"},
			expected:    map[string]string{"a": "1", "bb": "2", "c": "3"},
		},
		{
			description: "corner: non-ASCII uppercase key is lowercased and keeps its value",
			input:       map[string]string{"ÄRGER": "x"},
			expected:    map[string]string{"ärger": "x"},
		},
		{
			description: "corner: value is not taken from a different key's lowercased form",
			input:       map[string]string{"Key": "upper", "other": "lower"},
			expected:    map[string]string{"key": "upper", "other": "lower"},
		},
	}

	for _, tc := range cases {
		t.Run(tc.description, func(t *testing.T) {
			got := PMetadata(tc.input)
			if got == nil {
				t.Fatalf("PMetadata returned nil, expected %v", tc.expected)
			}
			if len(got) != len(tc.expected) {
				t.Fatalf("PMetadata returned %d keys, expected %d (%v)", len(got), len(tc.expected), tc.expected)
			}
			for k, want := range tc.expected {
				v, ok := got[k]
				if !ok || v == nil {
					t.Errorf("key %q missing, expected value %q", k, want)
					continue
				}
				if *v != want {
					t.Errorf("key %q = %q, expected %q", k, *v, want)
				}
			}
		})
	}

}
