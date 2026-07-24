extends Resource
class_name CreditsEntry
## A single credit entry, grouped by role and sorted alphabetically by the handler.

## Role/category this entry belongs to, e.g. "Programmer", "Artist".
@export var role: String

## Person's name.
@export var entry_name: String
