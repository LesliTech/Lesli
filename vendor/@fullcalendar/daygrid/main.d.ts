
import { Dictionary, DateComponent, ViewProps, RefObject, ChunkConfigRowContent, ChunkContentCallbackArgs, VNode, createElement, DateProfile, DateProfileGenerator, DayTableModel, Seg, DateMarker, ViewApi, MountArg, VUIEvent, EventApi, Identity, ClassNamesGenerator, CustomContentGenerator, DidMountHandler, WillUnmountHandler, ViewContext, Hit, Duration, EventStore, EventUiHash, DateSpan, EventInteractionState, CssDimValue, Slicer, DateRange, Ref, EventSegUiInteractionState, PluginDef } from '@fullcalendar/common';

declare abstract class TableView<State = Dictionary> extends DateComponent<ViewProps, State> {
    protected headerElRef: RefObject<HTMLTableCellElement>;
    renderSimpleLayout(headerRowContent: ChunkConfigRowContent, bodyContent: (contentArg: ChunkContentCallbackArgs) => VNode): createElement.JSX.Element;
    renderHScrollLayout(headerRowContent: ChunkConfigRowContent, bodyContent: (contentArg: ChunkContentCallbackArgs) => VNode, colCnt: number, dayMinWidth: number): createElement.JSX.Element;
}


declare class DayTableView extends TableView {
    private buildDayTableModel;
    private headerRef;
    private tableRef;
    render(): createElement.JSX.Element;
}
declare function buildDayTableModel(dateProfile: DateProfile, dateProfileGenerator: DateProfileGenerator): DayTableModel;


interface TableSeg extends Seg {
    row: number;
    firstCol: number;
    lastCol: number;
}

interface TableCellModel {
    key: string;
    date: DateMarker;
    extraHookProps?: Dictionary;
    extraDataAttrs?: Dictionary;
    extraClassNames?: string[];
}
interface MoreLinkArg {
    date: DateMarker;
    allSegs: TableSeg[];
    hiddenSegs: TableSeg[];
    moreCnt: number;
    dayEl: HTMLElement;
    ev: VUIEvent;
}
interface MoreLinkContentArg {
    num: number;
    text: string;
    view: ViewApi;
}
declare type MoreLinkMountArg = MountArg<MoreLinkContentArg>;

interface EventSegment {
    event: EventApi;
    start: Date;
    end: Date;
    isStart: boolean;
    isEnd: boolean;
}
declare type MoreLinkAction = MoreLinkSimpleAction | MoreLinkHandler;
declare type MoreLinkSimpleAction = 'popover' | 'week' | 'day' | 'timeGridWeek' | 'timeGridDay' | string;
interface MoreLinkArg$1 {
    date: Date;
    allDay: boolean;
    allSegs: EventSegment[];
    hiddenSegs: EventSegment[];
    jsEvent: VUIEvent;
    view: ViewApi;
}
declare type MoreLinkHandler = (arg: MoreLinkArg$1) => MoreLinkSimpleAction | void;


declare const OPTION_REFINERS: {
    moreLinkClick: Identity<MoreLinkAction>;
    moreLinkClassNames: Identity<ClassNamesGenerator<MoreLinkContentArg>>;
    moreLinkContent: Identity<CustomContentGenerator<MoreLinkContentArg>>;
    moreLinkDidMount: Identity<DidMountHandler<MountArg<MoreLinkContentArg>>>;
    moreLinkWillUnmount: Identity<WillUnmountHandler<MountArg<MoreLinkContentArg>>>;
};


declare type ExtraOptionRefiners = typeof OPTION_REFINERS;
declare module '@fullcalendar/common' {
    interface BaseOptionRefiners extends ExtraOptionRefiners {
    }
}

interface DayTableProps {
    dateProfile: DateProfile;
    dayTableModel: DayTableModel;
    nextDayThreshold: Duration;
    businessHours: EventStore;
    eventStore: EventStore;
    eventUiBases: EventUiHash;
    dateSelection: DateSpan | null;
    eventSelection: string;
    eventDrag: EventInteractionState | null;
    eventResize: EventInteractionState | null;
    colGroupNode: VNode;
    tableMinWidth: CssDimValue;
    renderRowIntro?: () => VNode;
    dayMaxEvents: boolean | number;
    dayMaxEventRows: boolean | number;
    expandRows: boolean;
    showWeekNumbers: boolean;
    headerAlignElRef?: RefObject<HTMLElement>;
    clientWidth: number | null;
    clientHeight: number | null;
    forPrint: boolean;
}
declare class DayTable extends DateComponent<DayTableProps, ViewContext> {
    private slicer;
    private tableRef;
    render(): createElement.JSX.Element;
    handleRootEl: (rootEl: HTMLDivElement | null) => void;
    prepareHits(): void;
    queryHit(positionLeft: number, positionTop: number): Hit;
}


declare class DayTableSlicer extends Slicer<TableSeg, [DayTableModel]> {
    forceDayIfListItem: boolean;
    sliceRange(dateRange: DateRange, dayTableModel: DayTableModel): TableSeg[];
}


interface TableProps {
    elRef?: Ref<HTMLDivElement>;
    dateProfile: DateProfile;
    cells: TableCellModel[][];
    renderRowIntro?: () => VNode;
    colGroupNode: VNode;
    tableMinWidth: CssDimValue;
    expandRows: boolean;
    showWeekNumbers: boolean;
    clientWidth: number | null;
    clientHeight: number | null;
    businessHourSegs: TableSeg[];
    bgEventSegs: TableSeg[];
    fgEventSegs: TableSeg[];
    dateSelectionSegs: TableSeg[];
    eventSelection: string;
    eventDrag: EventSegUiInteractionState | null;
    eventResize: EventSegUiInteractionState | null;
    dayMaxEvents: boolean | number;
    dayMaxEventRows: boolean | number;
    headerAlignElRef?: RefObject<HTMLElement>;
    forPrint: boolean;
}
interface TableState {
    morePopoverState: MorePopoverState | null;
}
interface MorePopoverState extends MoreLinkArg {
    currentFgEventSegs: TableSeg[];
    fromRow: number;
    fromCol: number;
}
declare class Table extends DateComponent<TableProps, TableState> {
    private splitBusinessHourSegs;
    private splitBgEventSegs;
    private splitFgEventSegs;
    private splitDateSelectionSegs;
    private splitEventDrag;
    private splitEventResize;
    private buildBuildMoreLinkText;
    private rootEl;
    private morePopoverRef;
    private rowRefs;
    private rowPositions;
    private colPositions;
    state: TableState;
    render(): createElement.JSX.Element;
    handleRootEl: (rootEl: HTMLElement | null) => void;
    handleMoreLinkClick: (arg: MoreLinkArg & {
        fromRow: number;
        fromCol: number;
    }) => void;
    handleMorePopoverClose: () => void;
    prepareHits(): void;
    positionToHit(leftPosition: any, topPosition: any): {
        dateSpan: {
            allDay: boolean;
            range: {
                start: Date;
                end: Date;
            };
        };
        dayEl: HTMLElement;
        relativeRect: {
            left: number;
            top: number;
            right: number;
            bottom: number;
        };
        layer: number;
        row: number;
        col: number;
    } | {
        row: any;
        col: any;
        dateSpan: {
            range: {
                start: Date;
                end: Date;
            };
            allDay: boolean;
        };
        dayEl: HTMLTableCellElement;
        relativeRect: {
            left: any;
            right: any;
            top: any;
            bottom: any;
        };
    };
    private getCellEl;
    private getCellRange;
}

declare const _default: PluginDef;

export default _default;
export { DayTableView as DayGridView, DayTable, DayTableSlicer, EventSegment, MoreLinkAction, MoreLinkArg$1 as MoreLinkArg, MoreLinkContentArg, MoreLinkHandler, MoreLinkMountArg, MoreLinkSimpleAction, Table, TableCellModel, TableSeg, TableView, buildDayTableModel };
