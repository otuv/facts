defmodule Facts.Event do
    defstruct id: "", tags: [], data: %{}

    alias Facts.Id
    alias Facts.Event

    def new(tags, data) when is_list(tags) do 
        %Event{id: Id.guid(), tags: tags, data: data}
    end
end