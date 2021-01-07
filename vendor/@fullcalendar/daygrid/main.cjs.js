/*!
FullCalendar v5.5.0
Docs & License: https://fullcalendar.io/
(c) 2020 Adam Shaw
*/
'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var common = require('@fullcalendar/common');
var tslib = require('tslib');
;

/* An abstract class for the daygrid views, as well as month view. Renders one or more rows of day cells.
----------------------------------------------------------------------------------------------------------------------*/
// It is a manager for a Table subcomponent, which does most of the heavy lifting.
// It is responsible for managing width/height.
var TableView = /** @class */ (function (_super) {
    tslib.__extends(TableView, _super);
    function TableView() {
        var _this = _super !== null && _super.apply(this, arguments) || this;
        _this.headerElRef = common.createRef();
        return _this;
    }
    TableView.prototype.renderSimpleLayout = function (headerRowContent, bodyContent) {
        var _a = this, props = _a.props, context = _a.context;
        var sections = [];
        var stickyHeaderDates = common.getStickyHeaderDates(context.options);
        if (headerRowContent) {
            sections.push({
                type: 'header',
                key: 'header',
                isSticky: stickyHeaderDates,
                chunk: {
                    elRef: this.headerElRef,
                    tableClassName: 'fc-col-header',
                    rowContent: headerRowContent,
                },
            });
        }
        sections.push({
            type: 'body',
            key: 'body',
            liquid: true,
            chunk: { content: bodyContent },
        });
        return (common.createElement(common.ViewRoot, { viewSpec: context.viewSpec }, function (rootElRef, classNames) { return (common.createElement("div", { ref: rootElRef, className: ['fc-daygrid'].concat(classNames).join(' ') },
            common.createElement(common.SimpleScrollGrid, { liquid: !props.isHeightAuto && !props.forPrint, cols: [] /* TODO: make optional? */, sections: sections }))); }));
    };
    TableView.prototype.renderHScrollLayout = function (headerRowContent, bodyContent, colCnt, dayMinWidth) {
        var ScrollGrid = this.context.pluginHooks.scrollGridImpl;
        if (!ScrollGrid) {
            throw new Error('No ScrollGrid implementation');
        }
        var _a = this, props = _a.props, context = _a.context;
        var stickyHeaderDates = !props.forPrint && common.getStickyHeaderDates(context.options);
        var stickyFooterScrollbar = !props.forPrint && common.getStickyFooterScrollbar(context.options);
        var sections = [];
        if (headerRowContent) {
            sections.push({
                type: 'header',
                key: 'header',
                isSticky: stickyHeaderDates,
                chunks: [{
                        key: 'main',
                        elRef: this.headerElRef,
                        tableClassName: 'fc-col-header',
                        rowContent: headerRowContent,
                    }],
            });
        }
        sections.push({
            type: 'body',
            key: 'body',
            liquid: true,
            chunks: [{
                    key: 'main',
                    content: bodyContent,
                }],
        });
        if (stickyFooterScrollbar) {
            sections.push({
                type: 'footer',
                key: 'footer',
                isSticky: true,
                chunks: [{
                        key: 'main',
                        content: common.renderScrollShim,
                    }],
            });
        }
        return (common.createElement(common.ViewRoot, { viewSpec: context.viewSpec }, function (rootElRef, classNames) { return (common.createElement("div", { ref: rootElRef, className: ['fc-daygrid'].concat(classNames).join(' ') },
            common.createElement(ScrollGrid, { liquid: !props.isHeightAuto && !props.forPrint, colGroups: [{ cols: [{ span: colCnt, minWidth: dayMinWidth }] }], sections: sections }))); }));
    };
    return TableView;
}(common.DateComponent));

function splitSegsByRow(segs, rowCnt) {
    var byRow = [];
    for (var i = 0; i < rowCnt; i += 1) {
        byRow[i] = [];
    }
    for (var _i = 0, segs_1 = segs; _i < segs_1.length; _i++) {
        var seg = segs_1[_i];
        byRow[seg.row].push(seg);
    }
    return byRow;
}
function splitSegsByFirstCol(segs, colCnt) {
    var byCol = [];
    for (var i = 0; i < colCnt; i += 1) {
        byCol[i] = [];
    }
    for (var _i = 0, segs_2 = segs; _i < segs_2.length; _i++) {
        var seg = segs_2[_i];
        byCol[seg.firstCol].push(seg);
    }
    return byCol;
}
function splitInteractionByRow(ui, rowCnt) {
    var byRow = [];
    if (!ui) {
        for (var i = 0; i < rowCnt; i += 1) {
            byRow[i] = null;
        }
    }
    else {
        for (var i = 0; i < rowCnt; i += 1) {
            byRow[i] = {
                affectedInstances: ui.affectedInstances,
                isEvent: ui.isEvent,
                segs: [],
            };
        }
        for (var _i = 0, _a = ui.segs; _i < _a.length; _i++) {
            var seg = _a[_i];
            byRow[seg.row].segs.push(seg);
        }
    }
    return byRow;
}

var TableCellTop = /** @class */ (function (_super) {
    tslib.__extends(TableCellTop, _super);
    function TableCellTop() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    TableCellTop.prototype.render = function () {
        var props = this.props;
        var navLinkAttrs = this.context.options.navLinks
            ? { 'data-navlink': common.buildNavLinkData(props.date), tabIndex: 0 }
            : {};
        return (common.createElement(common.DayCellContent, { date: props.date, dateProfile: props.dateProfile, todayRange: props.todayRange, showDayNumber: props.showDayNumber, extraHookProps: props.extraHookProps, defaultContent: renderTopInner }, function (innerElRef, innerContent) { return ((innerContent || props.forceDayTop) && (common.createElement("div", { className: "fc-daygrid-day-top", ref: innerElRef },
            common.createElement("a", tslib.__assign({ className: "fc-daygrid-day-number" }, navLinkAttrs), innerContent || common.createElement(common.Fragment, null, "\u00A0"))))); }));
    };
    return TableCellTop;
}(common.BaseComponent));
function renderTopInner(props) {
    return props.dayNumberText;
}

var DEFAULT_WEEK_NUM_FORMAT = common.createFormatter({ week: 'narrow' });
var TableCell = /** @class */ (function (_super) {
    tslib.__extends(TableCell, _super);
    function TableCell() {
        var _this = _super !== null && _super.apply(this, arguments) || this;
        _this.handleRootEl = function (el) {
            _this.rootEl = el;
            common.setRef(_this.props.elRef, el);
        };
        _this.handleMoreLinkClick = function (ev) {
            var props = _this.props;
            if (props.onMoreClick) {
                var allSegs = props.segsByEachCol;
                var hiddenSegs = allSegs.filter(function (seg) { return props.segIsHidden[seg.eventRange.instance.instanceId]; });
                props.onMoreClick({
                    date: props.date,
                    allSegs: allSegs,
                    hiddenSegs: hiddenSegs,
                    moreCnt: props.moreCnt,
                    dayEl: _this.rootEl,
                    ev: ev,
                });
            }
        };
        return _this;
    }
    TableCell.prototype.render = function () {
        var _this = this;
        var _a = this.context, options = _a.options, viewApi = _a.viewApi;
        var props = this.props;
        var date = props.date, dateProfile = props.dateProfile;
        var hookProps = {
            num: props.moreCnt,
            text: props.buildMoreLinkText(props.moreCnt),
            view: viewApi,
        };
        var navLinkAttrs = options.navLinks
            ? { 'data-navlink': common.buildNavLinkData(date, 'week'), tabIndex: 0 }
            : {};
        return (common.createElement(common.DayCellRoot, { date: date, dateProfile: dateProfile, todayRange: props.todayRange, showDayNumber: props.showDayNumber, extraHookProps: props.extraHookProps, elRef: this.handleRootEl }, function (dayElRef, dayClassNames, rootDataAttrs, isDisabled) { return (common.createElement("td", tslib.__assign({ ref: dayElRef, className: ['fc-daygrid-day'].concat(dayClassNames, props.extraClassNames || []).join(' ') }, rootDataAttrs, props.extraDataAttrs),
            common.createElement("div", { className: "fc-daygrid-day-frame fc-scrollgrid-sync-inner", ref: props.innerElRef /* different from hook system! RENAME */ },
                props.showWeekNumber && (common.createElement(common.WeekNumberRoot, { date: date, defaultFormat: DEFAULT_WEEK_NUM_FORMAT }, function (weekElRef, weekClassNames, innerElRef, innerContent) { return (common.createElement("a", tslib.__assign({ ref: weekElRef, className: ['fc-daygrid-week-number'].concat(weekClassNames).join(' ') }, navLinkAttrs), innerContent)); })),
                !isDisabled && (common.createElement(TableCellTop, { date: date, dateProfile: dateProfile, showDayNumber: props.showDayNumber, forceDayTop: props.forceDayTop, todayRange: props.todayRange, extraHookProps: props.extraHookProps })),
                common.createElement("div", { className: "fc-daygrid-day-events", ref: props.fgContentElRef, style: { paddingBottom: props.fgPaddingBottom } },
                    props.fgContent,
                    Boolean(props.moreCnt) && (common.createElement("div", { className: "fc-daygrid-day-bottom", style: { marginTop: props.moreMarginTop } },
                        common.createElement(common.RenderHook, { hookProps: hookProps, classNames: options.moreLinkClassNames, content: options.moreLinkContent, defaultContent: renderMoreLinkInner, didMount: options.moreLinkDidMount, willUnmount: options.moreLinkWillUnmount }, function (rootElRef, classNames, innerElRef, innerContent) { return (common.createElement("a", { ref: rootElRef, className: ['fc-daygrid-more-link'].concat(classNames).join(' '), onClick: _this.handleMoreLinkClick }, innerContent)); })))),
                common.createElement("div", { className: "fc-daygrid-day-bg" }, props.bgContent)))); }));
    };
    return TableCell;
}(common.DateComponent));
TableCell.addPropsEquality({
    onMoreClick: true,
});
function renderMoreLinkInner(props) {
    return props.text;
}

var DEFAULT_TABLE_EVENT_TIME_FORMAT = common.createFormatter({
    hour: 'numeric',
    minute: '2-digit',
    omitZeroMinute: true,
    meridiem: 'narrow',
});
function hasListItemDisplay(seg) {
    var display = seg.eventRange.ui.display;
    return display === 'list-item' || (display === 'auto' &&
        !seg.eventRange.def.allDay &&
        seg.firstCol === seg.lastCol && // can't be multi-day
        seg.isStart && // "
        seg.isEnd // "
    );
}

var TableListItemEvent = /** @class */ (function (_super) {
    tslib.__extends(TableListItemEvent, _super);
    function TableListItemEvent() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    TableListItemEvent.prototype.render = function () {
        var _a = this, props = _a.props, context = _a.context;
        var timeFormat = context.options.eventTimeFormat || DEFAULT_TABLE_EVENT_TIME_FORMAT;
        var timeText = common.buildSegTimeText(props.seg, timeFormat, context, true, props.defaultDisplayEventEnd);
        return (common.createElement(common.EventRoot, { seg: props.seg, timeText: timeText, defaultContent: renderInnerContent, isDragging: props.isDragging, isResizing: false, isDateSelecting: false, isSelected: props.isSelected, isPast: props.isPast, isFuture: props.isFuture, isToday: props.isToday }, function (rootElRef, classNames, innerElRef, innerContent) { return ( // we don't use styles!
        common.createElement("a", tslib.__assign({ className: ['fc-daygrid-event', 'fc-daygrid-dot-event'].concat(classNames).join(' '), ref: rootElRef }, getSegAnchorAttrs(props.seg)), innerContent)); }));
    };
    return TableListItemEvent;
}(common.BaseComponent));
function renderInnerContent(innerProps) {
    return (common.createElement(common.Fragment, null,
        common.createElement("div", { className: "fc-daygrid-event-dot", style: { borderColor: innerProps.borderColor || innerProps.backgroundColor } }),
        innerProps.timeText && (common.createElement("div", { className: "fc-event-time" }, innerProps.timeText)),
        common.createElement("div", { className: "fc-event-title" }, innerProps.event.title || common.createElement(common.Fragment, null, "\u00A0"))));
}
function getSegAnchorAttrs(seg) {
    var url = seg.eventRange.def.url;
    return url ? { href: url } : {};
}

var TableBlockEvent = /** @class */ (function (_super) {
    tslib.__extends(TableBlockEvent, _super);
    function TableBlockEvent() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    TableBlockEvent.prototype.render = function () {
        var props = this.props;
        return (common.createElement(common.StandardEvent, tslib.__assign({}, props, { extraClassNames: ['fc-daygrid-event', 'fc-daygrid-block-event', 'fc-h-event'], defaultTimeFormat: DEFAULT_TABLE_EVENT_TIME_FORMAT, defaultDisplayEventEnd: props.defaultDisplayEventEnd, disableResizing: !props.seg.eventRange.def.allDay })));
    };
    return TableBlockEvent;
}(common.BaseComponent));

function computeFgSegPlacement(// for one row. TODO: print mode?
cellModels, segs, dayMaxEvents, dayMaxEventRows, eventHeights, maxContentHeight, colCnt, eventOrderSpecs) {
    var colPlacements = []; // if event spans multiple cols, its present in each col
    var moreCnts = []; // by-col
    var segIsHidden = {};
    var segTops = {}; // always populated for each seg
    var segMarginTops = {}; // simetimes populated for each seg
    var moreTops = {};
    var paddingBottoms = {}; // for each cell's inner-wrapper div
    for (var i = 0; i < colCnt; i += 1) {
        colPlacements.push([]);
        moreCnts.push(0);
    }
    segs = common.sortEventSegs(segs, eventOrderSpecs);
    for (var _i = 0, segs_1 = segs; _i < segs_1.length; _i++) {
        var seg = segs_1[_i];
        var instanceId = seg.eventRange.instance.instanceId;
        var eventHeight = eventHeights[instanceId + ':' + seg.firstCol];
        placeSeg(seg, eventHeight || 0); // will keep colPlacements sorted by top
    }
    if (dayMaxEvents === true || dayMaxEventRows === true) {
        limitByMaxHeight(moreCnts, segIsHidden, colPlacements, maxContentHeight); // populates moreCnts/segIsHidden
    }
    else if (typeof dayMaxEvents === 'number') {
        limitByMaxEvents(moreCnts, segIsHidden, colPlacements, dayMaxEvents); // populates moreCnts/segIsHidden
    }
    else if (typeof dayMaxEventRows === 'number') {
        limitByMaxRows(moreCnts, segIsHidden, colPlacements, dayMaxEventRows); // populates moreCnts/segIsHidden
    }
    // computes segTops/segMarginTops/moreTops/paddingBottoms
    for (var col = 0; col < colCnt; col += 1) {
        var placements = colPlacements[col];
        var currentNonAbsBottom = 0;
        var currentAbsHeight = 0;
        for (var _a = 0, placements_1 = placements; _a < placements_1.length; _a++) {
            var placement = placements_1[_a];
            var seg = placement.seg;
            if (!segIsHidden[seg.eventRange.instance.instanceId]) {
                segTops[seg.eventRange.instance.instanceId] = placement.top; // from top of container
                if (seg.firstCol === seg.lastCol && seg.isStart && seg.isEnd) { // TODO: simpler way? NOT DRY
                    segMarginTops[seg.eventRange.instance.instanceId] =
                        placement.top - currentNonAbsBottom; // from previous seg bottom
                    currentAbsHeight = 0;
                    currentNonAbsBottom = placement.bottom;
                }
                else { // multi-col event, abs positioned
                    currentAbsHeight = placement.bottom - currentNonAbsBottom;
                }
            }
        }
        if (currentAbsHeight) {
            if (moreCnts[col]) {
                moreTops[col] = currentAbsHeight;
            }
            else {
                paddingBottoms[col] = currentAbsHeight;
            }
        }
    }
    function placeSeg(seg, segHeight) {
        if (!tryPlaceSegAt(seg, segHeight, 0)) {
            for (var col = seg.firstCol; col <= seg.lastCol; col += 1) {
                for (var _i = 0, _a = colPlacements[col]; _i < _a.length; _i++) { // will repeat multi-day segs!!!!!!! bad!!!!!!
                    var placement = _a[_i];
                    if (tryPlaceSegAt(seg, segHeight, placement.bottom)) {
                        return;
                    }
                }
            }
        }
    }
    function tryPlaceSegAt(seg, segHeight, top) {
        if (canPlaceSegAt(seg, segHeight, top)) {
            for (var col = seg.firstCol; col <= seg.lastCol; col += 1) {
                var placements = colPlacements[col];
                var insertionIndex = 0;
                while (insertionIndex < placements.length &&
                    top >= placements[insertionIndex].top) {
                    insertionIndex += 1;
                }
                placements.splice(insertionIndex, 0, {
                    seg: seg,
                    top: top,
                    bottom: top + segHeight,
                });
            }
            return true;
        }
        return false;
    }
    function canPlaceSegAt(seg, segHeight, top) {
        for (var col = seg.firstCol; col <= seg.lastCol; col += 1) {
            for (var _i = 0, _a = colPlacements[col]; _i < _a.length; _i++) {
                var placement = _a[_i];
                if (top < placement.bottom && top + segHeight > placement.top) { // collide?
                    return false;
                }
            }
        }
        return true;
    }
    // what does this do!?
    for (var instanceIdAndFirstCol in eventHeights) {
        if (!eventHeights[instanceIdAndFirstCol]) {
            segIsHidden[instanceIdAndFirstCol.split(':')[0]] = true;
        }
    }
    var segsByFirstCol = colPlacements.map(extractFirstColSegs); // operates on the sorted cols
    var segsByEachCol = colPlacements.map(function (placements, col) {
        var segsForCols = extractAllColSegs(placements);
        segsForCols = resliceDaySegs(segsForCols, cellModels[col].date, col);
        return segsForCols;
    });
    return {
        segsByFirstCol: segsByFirstCol,
        segsByEachCol: segsByEachCol,
        segIsHidden: segIsHidden,
        segTops: segTops,
        segMarginTops: segMarginTops,
        moreCnts: moreCnts,
        moreTops: moreTops,
        paddingBottoms: paddingBottoms,
    };
}
function extractFirstColSegs(oneColPlacements, col) {
    var segs = [];
    for (var _i = 0, oneColPlacements_1 = oneColPlacements; _i < oneColPlacements_1.length; _i++) {
        var placement = oneColPlacements_1[_i];
        if (placement.seg.firstCol === col) {
            segs.push(placement.seg);
        }
    }
    return segs;
}
function extractAllColSegs(oneColPlacements) {
    var segs = [];
    for (var _i = 0, oneColPlacements_2 = oneColPlacements; _i < oneColPlacements_2.length; _i++) {
        var placement = oneColPlacements_2[_i];
        segs.push(placement.seg);
    }
    return segs;
}
function limitByMaxHeight(hiddenCnts, segIsHidden, colPlacements, maxContentHeight) {
    limitEvents(hiddenCnts, segIsHidden, colPlacements, true, function (placement) { return placement.bottom <= maxContentHeight; });
}
function limitByMaxEvents(hiddenCnts, segIsHidden, colPlacements, dayMaxEvents) {
    limitEvents(hiddenCnts, segIsHidden, colPlacements, false, function (placement, levelIndex) { return levelIndex < dayMaxEvents; });
}
function limitByMaxRows(hiddenCnts, segIsHidden, colPlacements, dayMaxEventRows) {
    limitEvents(hiddenCnts, segIsHidden, colPlacements, true, function (placement, levelIndex) { return levelIndex < dayMaxEventRows; });
}
/*
populates the given hiddenCnts/segIsHidden, which are supplied empty.
TODO: return them instead
*/
function limitEvents(hiddenCnts, segIsHidden, colPlacements, _moreLinkConsumesLevel, isPlacementInBounds) {
    var colCnt = hiddenCnts.length;
    var segIsVisible = {}; // TODO: instead, use segIsHidden with true/false?
    var visibleColPlacements = []; // will mirror colPlacements
    for (var col = 0; col < colCnt; col += 1) {
        visibleColPlacements.push([]);
    }
    for (var col = 0; col < colCnt; col += 1) {
        var placements = colPlacements[col];
        var level = 0;
        for (var _i = 0, placements_2 = placements; _i < placements_2.length; _i++) {
            var placement = placements_2[_i];
            if (isPlacementInBounds(placement, level)) {
                recordVisible(placement);
            }
            else {
                recordHidden(placement, level, _moreLinkConsumesLevel);
            }
            // only considered a level if the seg had height
            if (placement.top !== placement.bottom) {
                level += 1;
            }
        }
    }
    function recordVisible(placement) {
        var seg = placement.seg;
        var instanceId = seg.eventRange.instance.instanceId;
        if (!segIsVisible[instanceId]) {
            segIsVisible[instanceId] = true;
            for (var col = seg.firstCol; col <= seg.lastCol; col += 1) {
                var destPlacements = visibleColPlacements[col];
                var newPosition = 0;
                // insert while keeping top sorted in each column
                while (newPosition < destPlacements.length &&
                    placement.top >= destPlacements[newPosition].top) {
                    newPosition += 1;
                }
                destPlacements.splice(newPosition, 0, placement);
            }
        }
    }
    function recordHidden(placement, currentLevel, moreLinkConsumesLevel) {
        var seg = placement.seg;
        var instanceId = seg.eventRange.instance.instanceId;
        if (!segIsHidden[instanceId]) {
            segIsHidden[instanceId] = true;
            for (var col = seg.firstCol; col <= seg.lastCol; col += 1) {
                hiddenCnts[col] += 1;
                var hiddenCnt = hiddenCnts[col];
                if (moreLinkConsumesLevel && hiddenCnt === 1 && currentLevel > 0) {
                    var doomedLevel = currentLevel - 1;
                    while (visibleColPlacements[col].length > doomedLevel) {
                        recordHidden(visibleColPlacements[col].pop(), // removes
                        visibleColPlacements[col].length, // will execute after the pop. will be the index of the removed placement
                        false);
                    }
                }
            }
        }
    }
}
// Given the events within an array of segment objects, reslice them to be in a single day
function resliceDaySegs(segs, dayDate, colIndex) {
    var dayStart = dayDate;
    var dayEnd = common.addDays(dayStart, 1);
    var dayRange = { start: dayStart, end: dayEnd };
    var newSegs = [];
    for (var _i = 0, segs_2 = segs; _i < segs_2.length; _i++) {
        var seg = segs_2[_i];
        var eventRange = seg.eventRange;
        var origRange = eventRange.range;
        var slicedRange = common.intersectRanges(origRange, dayRange);
        if (slicedRange) {
            newSegs.push(tslib.__assign(tslib.__assign({}, seg), { firstCol: colIndex, lastCol: colIndex, eventRange: {
                    def: eventRange.def,
                    ui: tslib.__assign(tslib.__assign({}, eventRange.ui), { durationEditable: false }),
                    instance: eventRange.instance,
                    range: slicedRange,
                }, isStart: seg.isStart && slicedRange.start.valueOf() === origRange.start.valueOf(), isEnd: seg.isEnd && slicedRange.end.valueOf() === origRange.end.valueOf() }));
        }
    }
    return newSegs;
}

var TableRow = /** @class */ (function (_super) {
    tslib.__extends(TableRow, _super);
    function TableRow() {
        var _this = _super !== null && _super.apply(this, arguments) || this;
        _this.cellElRefs = new common.RefMap(); // the <td>
        _this.frameElRefs = new common.RefMap(); // the fc-daygrid-day-frame
        _this.fgElRefs = new common.RefMap(); // the fc-daygrid-day-events
        _this.segHarnessRefs = new common.RefMap(); // indexed by "instanceId:firstCol"
        _this.rootElRef = common.createRef();
        _this.state = {
            framePositions: null,
            maxContentHeight: null,
            segHeights: {},
        };
        return _this;
    }
    TableRow.prototype.render = function () {
        var _this = this;
        var _a = this, props = _a.props, state = _a.state, context = _a.context;
        var colCnt = props.cells.length;
        var businessHoursByCol = splitSegsByFirstCol(props.businessHourSegs, colCnt);
        var bgEventSegsByCol = splitSegsByFirstCol(props.bgEventSegs, colCnt);
        var highlightSegsByCol = splitSegsByFirstCol(this.getHighlightSegs(), colCnt);
        var mirrorSegsByCol = splitSegsByFirstCol(this.getMirrorSegs(), colCnt);
        var _b = computeFgSegPlacement(props.cells, props.fgEventSegs, props.dayMaxEvents, props.dayMaxEventRows, state.segHeights, state.maxContentHeight, colCnt, context.options.eventOrder), paddingBottoms = _b.paddingBottoms, segsByFirstCol = _b.segsByFirstCol, segsByEachCol = _b.segsByEachCol, segIsHidden = _b.segIsHidden, segTops = _b.segTops, segMarginTops = _b.segMarginTops, moreCnts = _b.moreCnts, moreTops = _b.moreTops;
        var selectedInstanceHash = // TODO: messy way to compute this
         (props.eventDrag && props.eventDrag.affectedInstances) ||
            (props.eventResize && props.eventResize.affectedInstances) ||
            {};
        return (common.createElement("tr", { ref: this.rootElRef },
            props.renderIntro && props.renderIntro(),
            props.cells.map(function (cell, col) {
                var normalFgNodes = _this.renderFgSegs(segsByFirstCol[col], segIsHidden, segTops, segMarginTops, selectedInstanceHash, props.todayRange);
                var mirrorFgNodes = _this.renderFgSegs(mirrorSegsByCol[col], {}, segTops, // use same tops as real rendering
                {}, {}, props.todayRange, Boolean(props.eventDrag), Boolean(props.eventResize), false);
                return (common.createElement(TableCell, { key: cell.key, elRef: _this.cellElRefs.createRef(cell.key), innerElRef: _this.frameElRefs.createRef(cell.key) /* FF <td> problem, but okay to use for left/right. TODO: rename prop */, dateProfile: props.dateProfile, date: cell.date, showDayNumber: props.showDayNumbers, showWeekNumber: props.showWeekNumbers && col === 0, forceDayTop: props.showWeekNumbers /* even displaying weeknum for row, not necessarily day */, todayRange: props.todayRange, extraHookProps: cell.extraHookProps, extraDataAttrs: cell.extraDataAttrs, extraClassNames: cell.extraClassNames, moreCnt: moreCnts[col], buildMoreLinkText: props.buildMoreLinkText, onMoreClick: function (arg) {
                        props.onMoreClick(tslib.__assign(tslib.__assign({}, arg), { fromCol: col }));
                    }, segIsHidden: segIsHidden, moreMarginTop: moreTops[col] /* rename */, segsByEachCol: segsByEachCol[col], fgPaddingBottom: paddingBottoms[col], fgContentElRef: _this.fgElRefs.createRef(cell.key), fgContent: ( // Fragment scopes the keys
                    common.createElement(common.Fragment, null,
                        common.createElement(common.Fragment, null, normalFgNodes),
                        common.createElement(common.Fragment, null, mirrorFgNodes))), bgContent: ( // Fragment scopes the keys
                    common.createElement(common.Fragment, null,
                        _this.renderFillSegs(highlightSegsByCol[col], 'highlight'),
                        _this.renderFillSegs(businessHoursByCol[col], 'non-business'),
                        _this.renderFillSegs(bgEventSegsByCol[col], 'bg-event'))) }));
            })));
    };
    TableRow.prototype.componentDidMount = function () {
        this.updateSizing(true);
    };
    TableRow.prototype.componentDidUpdate = function (prevProps, prevState) {
        var currentProps = this.props;
        this.updateSizing(!common.isPropsEqual(prevProps, currentProps));
    };
    TableRow.prototype.getHighlightSegs = function () {
        var props = this.props;
        if (props.eventDrag && props.eventDrag.segs.length) { // messy check
            return props.eventDrag.segs;
        }
        if (props.eventResize && props.eventResize.segs.length) { // messy check
            return props.eventResize.segs;
        }
        return props.dateSelectionSegs;
    };
    TableRow.prototype.getMirrorSegs = function () {
        var props = this.props;
        if (props.eventResize && props.eventResize.segs.length) { // messy check
            return props.eventResize.segs;
        }
        return [];
    };
    TableRow.prototype.renderFgSegs = function (segs, segIsHidden, // does NOT mean display:hidden
    segTops, segMarginTops, selectedInstanceHash, todayRange, isDragging, isResizing, isDateSelecting) {
        var context = this.context;
        var eventSelection = this.props.eventSelection;
        var framePositions = this.state.framePositions;
        var defaultDisplayEventEnd = this.props.cells.length === 1; // colCnt === 1
        var nodes = [];
        if (framePositions) {
            for (var _i = 0, segs_1 = segs; _i < segs_1.length; _i++) {
                var seg = segs_1[_i];
                var instanceId = seg.eventRange.instance.instanceId;
                var isMirror = isDragging || isResizing || isDateSelecting;
                var isSelected = selectedInstanceHash[instanceId];
                var isInvisible = segIsHidden[instanceId] || isSelected;
                // TODO: simpler way? NOT DRY
                var isAbsolute = segIsHidden[instanceId] || isMirror || seg.firstCol !== seg.lastCol || !seg.isStart || !seg.isEnd;
                var marginTop = void 0;
                var top_1 = void 0;
                var left = void 0;
                var right = void 0;
                if (isAbsolute) {
                    top_1 = segTops[instanceId];
                    if (context.isRtl) {
                        right = 0;
                        left = framePositions.lefts[seg.lastCol] - framePositions.lefts[seg.firstCol];
                    }
                    else {
                        left = 0;
                        right = framePositions.rights[seg.firstCol] - framePositions.rights[seg.lastCol];
                    }
                }
                else {
                    marginTop = segMarginTops[instanceId];
                }
                /*
                known bug: events that are force to be list-item but span multiple days still take up space in later columns
                */
                nodes.push(common.createElement("div", { className: 'fc-daygrid-event-harness' + (isAbsolute ? ' fc-daygrid-event-harness-abs' : ''), key: instanceId, 
                    // in print mode when in mult cols, could collide
                    ref: isMirror ? null : this.segHarnessRefs.createRef(instanceId + ':' + seg.firstCol), style: {
                        visibility: isInvisible ? 'hidden' : '',
                        marginTop: marginTop || '',
                        top: top_1 || '',
                        left: left || '',
                        right: right || '',
                    } }, hasListItemDisplay(seg) ? (common.createElement(TableListItemEvent, tslib.__assign({ seg: seg, isDragging: isDragging, isSelected: instanceId === eventSelection, defaultDisplayEventEnd: defaultDisplayEventEnd }, common.getSegMeta(seg, todayRange)))) : (common.createElement(TableBlockEvent, tslib.__assign({ seg: seg, isDragging: isDragging, isResizing: isResizing, isDateSelecting: isDateSelecting, isSelected: instanceId === eventSelection, defaultDisplayEventEnd: defaultDisplayEventEnd }, common.getSegMeta(seg, todayRange))))));
            }
        }
        return nodes;
    };
    TableRow.prototype.renderFillSegs = function (segs, fillType) {
        var isRtl = this.context.isRtl;
        var todayRange = this.props.todayRange;
        var framePositions = this.state.framePositions;
        var nodes = [];
        if (framePositions) {
            for (var _i = 0, segs_2 = segs; _i < segs_2.length; _i++) {
                var seg = segs_2[_i];
                var leftRightCss = isRtl ? {
                    right: 0,
                    left: framePositions.lefts[seg.lastCol] - framePositions.lefts[seg.firstCol],
                } : {
                    left: 0,
                    right: framePositions.rights[seg.firstCol] - framePositions.rights[seg.lastCol],
                };
                nodes.push(common.createElement("div", { key: common.buildEventRangeKey(seg.eventRange), className: "fc-daygrid-bg-harness", style: leftRightCss }, fillType === 'bg-event' ?
                    common.createElement(common.BgEvent, tslib.__assign({ seg: seg }, common.getSegMeta(seg, todayRange))) :
                    common.renderFill(fillType)));
            }
        }
        return common.createElement.apply(void 0, tslib.__spreadArrays([common.Fragment, {}], nodes));
    };
    TableRow.prototype.updateSizing = function (isExternalSizingChange) {
        var _a = this, props = _a.props, frameElRefs = _a.frameElRefs;
        if (props.clientWidth !== null) { // positioning ready?
            if (isExternalSizingChange) {
                var frameEls = props.cells.map(function (cell) { return frameElRefs.currentMap[cell.key]; });
                if (frameEls.length) {
                    var originEl = this.rootElRef.current;
                    this.setState({
                        framePositions: new common.PositionCache(originEl, frameEls, true, // isHorizontal
                        false),
                    });
                }
            }
            var limitByContentHeight = props.dayMaxEvents === true || props.dayMaxEventRows === true;
            this.setState({
                segHeights: this.computeSegHeights(),
                maxContentHeight: limitByContentHeight ? this.computeMaxContentHeight() : null,
            });
        }
    };
    TableRow.prototype.computeSegHeights = function () {
        return common.mapHash(this.segHarnessRefs.currentMap, function (eventHarnessEl) { return (eventHarnessEl.getBoundingClientRect().height); });
    };
    TableRow.prototype.computeMaxContentHeight = function () {
        var firstKey = this.props.cells[0].key;
        var cellEl = this.cellElRefs.currentMap[firstKey];
        var fcContainerEl = this.fgElRefs.currentMap[firstKey];
        return cellEl.getBoundingClientRect().bottom - fcContainerEl.getBoundingClientRect().top;
    };
    TableRow.prototype.getCellEls = function () {
        var elMap = this.cellElRefs.currentMap;
        return this.props.cells.map(function (cell) { return elMap[cell.key]; });
    };
    return TableRow;
}(common.DateComponent));
TableRow.addPropsEquality({
    onMoreClick: true,
});
TableRow.addStateEquality({
    segHeights: common.isPropsEqual,
});

var PADDING_FROM_VIEWPORT = 10;
var SCROLL_DEBOUNCE = 10;
var Popover = /** @class */ (function (_super) {
    tslib.__extends(Popover, _super);
    function Popover() {
        var _this = _super !== null && _super.apply(this, arguments) || this;
        _this.repositioner = new common.DelayedRunner(_this.updateSize.bind(_this));
        _this.handleRootEl = function (el) {
            _this.rootEl = el;
            if (_this.props.elRef) {
                common.setRef(_this.props.elRef, el);
            }
        };
        // Triggered when the user clicks *anywhere* in the document, for the autoHide feature
        _this.handleDocumentMousedown = function (ev) {
            var onClose = _this.props.onClose;
            // only hide the popover if the click happened outside the popover
            if (onClose && !_this.rootEl.contains(ev.target)) {
                onClose();
            }
        };
        _this.handleDocumentScroll = function () {
            _this.repositioner.request(SCROLL_DEBOUNCE);
        };
        _this.handleCloseClick = function () {
            var onClose = _this.props.onClose;
            if (onClose) {
                onClose();
            }
        };
        return _this;
    }
    Popover.prototype.render = function () {
        var theme = this.context.theme;
        var props = this.props;
        var classNames = [
            'fc-popover',
            theme.getClass('popover'),
        ].concat(props.extraClassNames || []);
        return (common.createElement("div", tslib.__assign({ className: classNames.join(' ') }, props.extraAttrs, { ref: this.handleRootEl }),
            common.createElement("div", { className: 'fc-popover-header ' + theme.getClass('popoverHeader') },
                common.createElement("span", { className: "fc-popover-title" }, props.title),
                common.createElement("span", { className: 'fc-popover-close ' + theme.getIconClass('close'), onClick: this.handleCloseClick })),
            common.createElement("div", { className: 'fc-popover-body ' + theme.getClass('popoverContent') }, props.children)));
    };
    Popover.prototype.componentDidMount = function () {
        document.addEventListener('mousedown', this.handleDocumentMousedown);
        document.addEventListener('scroll', this.handleDocumentScroll);
        this.updateSize();
    };
    Popover.prototype.componentWillUnmount = function () {
        document.removeEventListener('mousedown', this.handleDocumentMousedown);
        document.removeEventListener('scroll', this.handleDocumentScroll);
    };
    // TODO: adjust on window resize
    /*
    NOTE: the popover is position:fixed, so coordinates are relative to the viewport
    NOTE: the PARENT calls this as well, on window resize. we would have wanted to use the repositioner,
          but need to ensure that all other components have updated size first (for alignmentEl)
    */
    Popover.prototype.updateSize = function () {
        var _a = this.props, alignmentEl = _a.alignmentEl, topAlignmentEl = _a.topAlignmentEl;
        var rootEl = this.rootEl;
        if (!rootEl) {
            return; // not sure why this was null, but we shouldn't let external components call updateSize() anyway
        }
        var dims = rootEl.getBoundingClientRect(); // only used for width,height
        var alignment = alignmentEl.getBoundingClientRect();
        var top = topAlignmentEl ? topAlignmentEl.getBoundingClientRect().top : alignment.top;
        top = Math.min(top, window.innerHeight - dims.height - PADDING_FROM_VIEWPORT);
        top = Math.max(top, PADDING_FROM_VIEWPORT);
        var left;
        if (this.context.isRtl) {
            left = alignment.right - dims.width;
        }
        else {
            left = alignment.left;
        }
        left = Math.min(left, window.innerWidth - dims.width - PADDING_FROM_VIEWPORT);
        left = Math.max(left, PADDING_FROM_VIEWPORT);
        common.applyStyle(rootEl, { top: top, left: left });
    };
    return Popover;
}(common.BaseComponent));

var MorePopover = /** @class */ (function (_super) {
    tslib.__extends(MorePopover, _super);
    function MorePopover() {
        var _this = _super !== null && _super.apply(this, arguments) || this;
        _this.rootElRef = common.createRef();
        return _this;
    }
    MorePopover.prototype.render = function () {
        var _a = this.context, options = _a.options, dateEnv = _a.dateEnv;
        var props = this.props;
        var date = props.date, hiddenInstances = props.hiddenInstances, todayRange = props.todayRange, dateProfile = props.dateProfile, selectedInstanceId = props.selectedInstanceId;
        var title = dateEnv.format(date, options.dayPopoverFormat);
        return (common.createElement(common.DayCellRoot, { date: date, dateProfile: dateProfile, todayRange: todayRange, elRef: this.rootElRef }, function (rootElRef, dayClassNames, dataAttrs) { return (common.createElement(Popover, { elRef: rootElRef, title: title, extraClassNames: ['fc-more-popover'].concat(dayClassNames), extraAttrs: dataAttrs, onClose: props.onCloseClick, alignmentEl: props.alignmentEl, topAlignmentEl: props.topAlignmentEl },
            common.createElement(common.DayCellContent, { date: date, dateProfile: dateProfile, todayRange: todayRange }, function (innerElRef, innerContent) { return (innerContent &&
                common.createElement("div", { className: "fc-more-popover-misc", ref: innerElRef }, innerContent)); }),
            props.segs.map(function (seg) {
                var instanceId = seg.eventRange.instance.instanceId;
                return (common.createElement("div", { className: "fc-daygrid-event-harness", key: instanceId, style: {
                        visibility: hiddenInstances[instanceId] ? 'hidden' : '',
                    } }, hasListItemDisplay(seg) ? (common.createElement(TableListItemEvent, tslib.__assign({ seg: seg, isDragging: false, isSelected: instanceId === selectedInstanceId, defaultDisplayEventEnd: false }, common.getSegMeta(seg, todayRange)))) : (common.createElement(TableBlockEvent, tslib.__assign({ seg: seg, isDragging: false, isResizing: false, isDateSelecting: false, isSelected: instanceId === selectedInstanceId, defaultDisplayEventEnd: false }, common.getSegMeta(seg, todayRange))))));
            }))); }));
    };
    MorePopover.prototype.positionToHit = function (positionLeft, positionTop, originEl) {
        var rootEl = this.rootElRef.current;
        if (!originEl || !rootEl) { // why?
            return null;
        }
        var originRect = originEl.getBoundingClientRect();
        var elRect = rootEl.getBoundingClientRect();
        var newOriginLeft = elRect.left - originRect.left;
        var newOriginTop = elRect.top - originRect.top;
        var localLeft = positionLeft - newOriginLeft;
        var localTop = positionTop - newOriginTop;
        var date = this.props.date;
        if ( // ugly way to detect intersection
        localLeft >= 0 && localLeft < elRect.width &&
            localTop >= 0 && localTop < elRect.height) {
            return {
                dateSpan: {
                    allDay: true,
                    range: { start: date, end: common.addDays(date, 1) },
                },
                dayEl: rootEl,
                relativeRect: {
                    left: newOriginLeft,
                    top: newOriginTop,
                    right: elRect.width,
                    bottom: elRect.height,
                },
                layer: 1,
            };
        }
        return null;
    };
    return MorePopover;
}(common.DateComponent));

var Table = /** @class */ (function (_super) {
    tslib.__extends(Table, _super);
    function Table() {
        var _this = _super !== null && _super.apply(this, arguments) || this;
        _this.splitBusinessHourSegs = common.memoize(splitSegsByRow);
        _this.splitBgEventSegs = common.memoize(splitSegsByRow);
        _this.splitFgEventSegs = common.memoize(splitSegsByRow);
        _this.splitDateSelectionSegs = common.memoize(splitSegsByRow);
        _this.splitEventDrag = common.memoize(splitInteractionByRow);
        _this.splitEventResize = common.memoize(splitInteractionByRow);
        _this.buildBuildMoreLinkText = common.memoize(buildBuildMoreLinkText);
        _this.morePopoverRef = common.createRef();
        _this.rowRefs = new common.RefMap();
        _this.state = {
            morePopoverState: null,
        };
        _this.handleRootEl = function (rootEl) {
            _this.rootEl = rootEl;
            common.setRef(_this.props.elRef, rootEl);
        };
        // TODO: bad names "more link click" versus "more click"
        _this.handleMoreLinkClick = function (arg) {
            var context = _this.context;
            var dateEnv = context.dateEnv;
            var clickOption = context.options.moreLinkClick;
            function segForPublic(seg) {
                var _a = seg.eventRange, def = _a.def, instance = _a.instance, range = _a.range;
                return {
                    event: new common.EventApi(context, def, instance),
                    start: dateEnv.toDate(range.start),
                    end: dateEnv.toDate(range.end),
                    isStart: seg.isStart,
                    isEnd: seg.isEnd,
                };
            }
            if (typeof clickOption === 'function') {
                clickOption = clickOption({
                    date: dateEnv.toDate(arg.date),
                    allDay: true,
                    allSegs: arg.allSegs.map(segForPublic),
                    hiddenSegs: arg.hiddenSegs.map(segForPublic),
                    jsEvent: arg.ev,
                    view: context.viewApi,
                }); // hack to handle void
            }
            if (!clickOption || clickOption === 'popover') {
                _this.setState({
                    morePopoverState: tslib.__assign(tslib.__assign({}, arg), { currentFgEventSegs: _this.props.fgEventSegs, fromRow: arg.fromRow, fromCol: arg.fromCol }),
                });
            }
            else if (typeof clickOption === 'string') { // a view name
                context.calendarApi.zoomTo(arg.date, clickOption);
            }
        };
        _this.handleMorePopoverClose = function () {
            _this.setState({
                morePopoverState: null,
            });
        };
        return _this;
    }
    Table.prototype.render = function () {
        var _this = this;
        var props = this.props;
        var dateProfile = props.dateProfile, dayMaxEventRows = props.dayMaxEventRows, dayMaxEvents = props.dayMaxEvents, expandRows = props.expandRows;
        var morePopoverState = this.state.morePopoverState;
        var rowCnt = props.cells.length;
        var businessHourSegsByRow = this.splitBusinessHourSegs(props.businessHourSegs, rowCnt);
        var bgEventSegsByRow = this.splitBgEventSegs(props.bgEventSegs, rowCnt);
        var fgEventSegsByRow = this.splitFgEventSegs(props.fgEventSegs, rowCnt);
        var dateSelectionSegsByRow = this.splitDateSelectionSegs(props.dateSelectionSegs, rowCnt);
        var eventDragByRow = this.splitEventDrag(props.eventDrag, rowCnt);
        var eventResizeByRow = this.splitEventResize(props.eventResize, rowCnt);
        var buildMoreLinkText = this.buildBuildMoreLinkText(this.context.options.moreLinkText);
        var limitViaBalanced = dayMaxEvents === true || dayMaxEventRows === true;
        // if rows can't expand to fill fixed height, can't do balanced-height event limit
        // TODO: best place to normalize these options?
        if (limitViaBalanced && !expandRows) {
            limitViaBalanced = false;
            dayMaxEventRows = null;
            dayMaxEvents = null;
        }
        var classNames = [
            'fc-daygrid-body',
            limitViaBalanced ? 'fc-daygrid-body-balanced' : 'fc-daygrid-body-unbalanced',
            expandRows ? '' : 'fc-daygrid-body-natural',
        ];
        return (common.createElement("div", { className: classNames.join(' '), ref: this.handleRootEl, style: {
                // these props are important to give this wrapper correct dimensions for interactions
                // TODO: if we set it here, can we avoid giving to inner tables?
                width: props.clientWidth,
                minWidth: props.tableMinWidth,
            } },
            common.createElement(common.NowTimer, { unit: "day" }, function (nowDate, todayRange) { return (common.createElement(common.Fragment, null,
                common.createElement("table", { className: "fc-scrollgrid-sync-table", style: {
                        width: props.clientWidth,
                        minWidth: props.tableMinWidth,
                        height: expandRows ? props.clientHeight : '',
                    } },
                    props.colGroupNode,
                    common.createElement("tbody", null, props.cells.map(function (cells, row) { return (common.createElement(TableRow, { ref: _this.rowRefs.createRef(row), key: cells.length
                            ? cells[0].date.toISOString() /* best? or put key on cell? or use diff formatter? */
                            : row // in case there are no cells (like when resource view is loading)
                        , showDayNumbers: rowCnt > 1, showWeekNumbers: props.showWeekNumbers, todayRange: todayRange, dateProfile: dateProfile, cells: cells, renderIntro: props.renderRowIntro, businessHourSegs: businessHourSegsByRow[row], eventSelection: props.eventSelection, bgEventSegs: bgEventSegsByRow[row].filter(isSegAllDay) /* hack */, fgEventSegs: fgEventSegsByRow[row], dateSelectionSegs: dateSelectionSegsByRow[row], eventDrag: eventDragByRow[row], eventResize: eventResizeByRow[row], dayMaxEvents: dayMaxEvents, dayMaxEventRows: dayMaxEventRows, clientWidth: props.clientWidth, clientHeight: props.clientHeight, buildMoreLinkText: buildMoreLinkText, onMoreClick: function (arg) {
                            _this.handleMoreLinkClick(tslib.__assign(tslib.__assign({}, arg), { fromRow: row }));
                        } })); }))),
                (!props.forPrint && morePopoverState && morePopoverState.currentFgEventSegs === props.fgEventSegs) && (common.createElement(MorePopover, { ref: _this.morePopoverRef, date: morePopoverState.date, dateProfile: dateProfile, segs: morePopoverState.allSegs, alignmentEl: morePopoverState.dayEl, topAlignmentEl: rowCnt === 1 ? props.headerAlignElRef.current : null, onCloseClick: _this.handleMorePopoverClose, selectedInstanceId: props.eventSelection, hiddenInstances: // yuck
                    (props.eventDrag ? props.eventDrag.affectedInstances : null) ||
                        (props.eventResize ? props.eventResize.affectedInstances : null) ||
                        {}, todayRange: todayRange })))); })));
    };
    // Hit System
    // ----------------------------------------------------------------------------------------------------
    Table.prototype.prepareHits = function () {
        this.rowPositions = new common.PositionCache(this.rootEl, this.rowRefs.collect().map(function (rowObj) { return rowObj.getCellEls()[0]; }), // first cell el in each row. TODO: not optimal
        false, true);
        this.colPositions = new common.PositionCache(this.rootEl, this.rowRefs.currentMap[0].getCellEls(), // cell els in first row
        true, // horizontal
        false);
    };
    Table.prototype.positionToHit = function (leftPosition, topPosition) {
        var morePopover = this.morePopoverRef.current;
        var morePopoverHit = morePopover ? morePopover.positionToHit(leftPosition, topPosition, this.rootEl) : null;
        var morePopoverState = this.state.morePopoverState;
        if (morePopoverHit) {
            return tslib.__assign({ row: morePopoverState.fromRow, col: morePopoverState.fromCol }, morePopoverHit);
        }
        var _a = this, colPositions = _a.colPositions, rowPositions = _a.rowPositions;
        var col = colPositions.leftToIndex(leftPosition);
        var row = rowPositions.topToIndex(topPosition);
        if (row != null && col != null) {
            return {
                row: row,
                col: col,
                dateSpan: {
                    range: this.getCellRange(row, col),
                    allDay: true,
                },
                dayEl: this.getCellEl(row, col),
                relativeRect: {
                    left: colPositions.lefts[col],
                    right: colPositions.rights[col],
                    top: rowPositions.tops[row],
                    bottom: rowPositions.bottoms[row],
                },
            };
        }
        return null;
    };
    Table.prototype.getCellEl = function (row, col) {
        return this.rowRefs.currentMap[row].getCellEls()[col]; // TODO: not optimal
    };
    Table.prototype.getCellRange = function (row, col) {
        var start = this.props.cells[row][col].date;
        var end = common.addDays(start, 1);
        return { start: start, end: end };
    };
    return Table;
}(common.DateComponent));
function buildBuildMoreLinkText(moreLinkTextInput) {
    if (typeof moreLinkTextInput === 'function') {
        return moreLinkTextInput;
    }
    return function (num) { return "+" + num + " " + moreLinkTextInput; };
}
function isSegAllDay(seg) {
    return seg.eventRange.def.allDay;
}

var DayTableSlicer = /** @class */ (function (_super) {
    tslib.__extends(DayTableSlicer, _super);
    function DayTableSlicer() {
        var _this = _super !== null && _super.apply(this, arguments) || this;
        _this.forceDayIfListItem = true;
        return _this;
    }
    DayTableSlicer.prototype.sliceRange = function (dateRange, dayTableModel) {
        return dayTableModel.sliceRange(dateRange);
    };
    return DayTableSlicer;
}(common.Slicer));

var DayTable = /** @class */ (function (_super) {
    tslib.__extends(DayTable, _super);
    function DayTable() {
        var _this = _super !== null && _super.apply(this, arguments) || this;
        _this.slicer = new DayTableSlicer();
        _this.tableRef = common.createRef();
        _this.handleRootEl = function (rootEl) {
            if (rootEl) {
                _this.context.registerInteractiveComponent(_this, { el: rootEl });
            }
            else {
                _this.context.unregisterInteractiveComponent(_this);
            }
        };
        return _this;
    }
    DayTable.prototype.render = function () {
        var _a = this, props = _a.props, context = _a.context;
        return (common.createElement(Table, tslib.__assign({ ref: this.tableRef, elRef: this.handleRootEl }, this.slicer.sliceProps(props, props.dateProfile, props.nextDayThreshold, context, props.dayTableModel), { dateProfile: props.dateProfile, cells: props.dayTableModel.cells, colGroupNode: props.colGroupNode, tableMinWidth: props.tableMinWidth, renderRowIntro: props.renderRowIntro, dayMaxEvents: props.dayMaxEvents, dayMaxEventRows: props.dayMaxEventRows, showWeekNumbers: props.showWeekNumbers, expandRows: props.expandRows, headerAlignElRef: props.headerAlignElRef, clientWidth: props.clientWidth, clientHeight: props.clientHeight, forPrint: props.forPrint })));
    };
    DayTable.prototype.prepareHits = function () {
        this.tableRef.current.prepareHits();
    };
    DayTable.prototype.queryHit = function (positionLeft, positionTop) {
        var rawHit = this.tableRef.current.positionToHit(positionLeft, positionTop);
        if (rawHit) {
            return {
                component: this,
                dateSpan: rawHit.dateSpan,
                dayEl: rawHit.dayEl,
                rect: {
                    left: rawHit.relativeRect.left,
                    right: rawHit.relativeRect.right,
                    top: rawHit.relativeRect.top,
                    bottom: rawHit.relativeRect.bottom,
                },
                layer: 0,
            };
        }
        return null;
    };
    return DayTable;
}(common.DateComponent));

var DayTableView = /** @class */ (function (_super) {
    tslib.__extends(DayTableView, _super);
    function DayTableView() {
        var _this = _super !== null && _super.apply(this, arguments) || this;
        _this.buildDayTableModel = common.memoize(buildDayTableModel);
        _this.headerRef = common.createRef();
        _this.tableRef = common.createRef();
        return _this;
    }
    DayTableView.prototype.render = function () {
        var _this = this;
        var _a = this.context, options = _a.options, dateProfileGenerator = _a.dateProfileGenerator;
        var props = this.props;
        var dayTableModel = this.buildDayTableModel(props.dateProfile, dateProfileGenerator);
        var headerContent = options.dayHeaders && (common.createElement(common.DayHeader, { ref: this.headerRef, dateProfile: props.dateProfile, dates: dayTableModel.headerDates, datesRepDistinctDays: dayTableModel.rowCnt === 1 }));
        var bodyContent = function (contentArg) { return (common.createElement(DayTable, { ref: _this.tableRef, dateProfile: props.dateProfile, dayTableModel: dayTableModel, businessHours: props.businessHours, dateSelection: props.dateSelection, eventStore: props.eventStore, eventUiBases: props.eventUiBases, eventSelection: props.eventSelection, eventDrag: props.eventDrag, eventResize: props.eventResize, nextDayThreshold: options.nextDayThreshold, colGroupNode: contentArg.tableColGroupNode, tableMinWidth: contentArg.tableMinWidth, dayMaxEvents: options.dayMaxEvents, dayMaxEventRows: options.dayMaxEventRows, showWeekNumbers: options.weekNumbers, expandRows: !props.isHeightAuto, headerAlignElRef: _this.headerElRef, clientWidth: contentArg.clientWidth, clientHeight: contentArg.clientHeight, forPrint: props.forPrint })); };
        return options.dayMinWidth
            ? this.renderHScrollLayout(headerContent, bodyContent, dayTableModel.colCnt, options.dayMinWidth)
            : this.renderSimpleLayout(headerContent, bodyContent);
    };
    return DayTableView;
}(TableView));
function buildDayTableModel(dateProfile, dateProfileGenerator) {
    var daySeries = new common.DaySeriesModel(dateProfile.renderRange, dateProfileGenerator);
    return new common.DayTableModel(daySeries, /year|month|week/.test(dateProfile.currentRangeUnit));
}

var TableDateProfileGenerator = /** @class */ (function (_super) {
    tslib.__extends(TableDateProfileGenerator, _super);
    function TableDateProfileGenerator() {
        return _super !== null && _super.apply(this, arguments) || this;
    }
    // Computes the date range that will be rendered.
    TableDateProfileGenerator.prototype.buildRenderRange = function (currentRange, currentRangeUnit, isRangeAllDay) {
        var dateEnv = this.props.dateEnv;
        var renderRange = _super.prototype.buildRenderRange.call(this, currentRange, currentRangeUnit, isRangeAllDay);
        var start = renderRange.start;
        var end = renderRange.end;
        var endOfWeek;
        // year and month views should be aligned with weeks. this is already done for week
        if (/^(year|month)$/.test(currentRangeUnit)) {
            start = dateEnv.startOfWeek(start);
            // make end-of-week if not already
            endOfWeek = dateEnv.startOfWeek(end);
            if (endOfWeek.valueOf() !== end.valueOf()) {
                end = common.addWeeks(endOfWeek, 1);
            }
        }
        // ensure 6 weeks
        if (this.props.monthMode &&
            this.props.fixedWeekCount) {
            var rowCnt = Math.ceil(// could be partial weeks due to hiddenDays
            common.diffWeeks(start, end));
            end = common.addWeeks(end, 6 - rowCnt);
        }
        return { start: start, end: end };
    };
    return TableDateProfileGenerator;
}(common.DateProfileGenerator));

var OPTION_REFINERS = {
    moreLinkClick: common.identity,
    moreLinkClassNames: common.identity,
    moreLinkContent: common.identity,
    moreLinkDidMount: common.identity,
    moreLinkWillUnmount: common.identity,
};

var main = common.createPlugin({
    initialView: 'dayGridMonth',
    optionRefiners: OPTION_REFINERS,
    views: {
        dayGrid: {
            component: DayTableView,
            dateProfileGeneratorClass: TableDateProfileGenerator,
        },
        dayGridDay: {
            type: 'dayGrid',
            duration: { days: 1 },
        },
        dayGridWeek: {
            type: 'dayGrid',
            duration: { weeks: 1 },
        },
        dayGridMonth: {
            type: 'dayGrid',
            duration: { months: 1 },
            monthMode: true,
            fixedWeekCount: true,
        },
    },
});

exports.DayGridView = DayTableView;
exports.DayTable = DayTable;
exports.DayTableSlicer = DayTableSlicer;
exports.Table = Table;
exports.TableView = TableView;
exports.buildDayTableModel = buildDayTableModel;
exports.default = main;
