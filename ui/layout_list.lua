local function do_layout(self)
    local pre
    for i=1,#self.children do
        local child = self.children[i]
        if i==1 then
            child:SetPoint('TOPLEFT',10,-10)
        else
            child:SetPoint('TOPLEFT',pre,'BOTTOMLEFT',0,-5)
        end

        pre = child.frame or child
    end
end

local methods = {
    ['AddChild'] = function(self,child)
        if not child then
            return
        end
        child:SetParent(self.container)
        table.insert(self.children,child)
    end
}

function BFF_ListLayout(parent)
    local scroll = CreateFrame('ScrollFrame',nil,parent,'UIPanelScrollFrameTemplate')
    scroll:EnableMouseWheel(true)

    scroll.ScrollBar:Hide()
    scroll.ScrollBar:ClearAllPoints()
    scroll.ScrollBar:SetPoint("TOPLEFT", scroll, "TOPRIGHT", -20, -20)
    scroll.ScrollBar:SetPoint("BOTTOMLEFT", scroll, "BOTTOMRIGHT", -20, 20)
    scroll:HookScript("OnScrollRangeChanged", function(self, xrange, yrange)
        self.ScrollBar:SetShown(math.floor(yrange) ~= 0)
    end)


    local container = CreateFrame('Frame',nil,scroll)
    --不要设置相对位置，特别是BOTTOMRIGHT，会导致控件显示不了
    --大小必须设置，否则控件也显示不出来，大小的值随便
    container:SetSize(100,100)
    scroll:SetScrollChild(container)


    local widget = {
        frame = scroll,
        container = container,
        children = {}
    }

    for m,f in pairs(methods) do
        widget[m] = f
    end

    setmetatable(widget,{__index = BFF_FrameBase})

    scroll:HookScript('OnShow',function(self,...)
        do_layout(self.obj)
    end)

    scroll.obj = widget
    return widget
end
