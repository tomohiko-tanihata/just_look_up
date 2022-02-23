var Sign = { positive: 0, negative: 1 };

var Axis = { x: 0, y: 1 };
gridNum = 8;

class Position {
    constructor(x, y) {
        this.x = x;
        this.y = y;
    }

    equals(position) { return this.x == position.x && this.y == position.y }
}

class Direction {
    constructor(sign, axis) {
        this.sign = sign;
        this.axis = axis;
    }
}

class Point {
    constructor(
        position,
        previousDirection = null,
        parent = null,
    ) {
        this.position = position;
        this.previousDirection = previousDirection;
        this.parent = parent;
    }

    get hasParent() { return this.parent != null; }
}

function movePosition(
    previous,
    direction,
    obstacles,
) {

    if (direction.axis == Axis.x) {
        if (direction.sign == Sign.positive) {
            x = gridNum - 1;
            var candidate = new Position(x, previous.y);
            candidates = (obstacles
                .filter((e) => (e.y == previous.y && e.x > previous.x))
                .sort((a, b) => a.x - b.x));
            if (candidates.length > 0) {
                candidate = candidates[0];
                x = candidate.x - 1;
            }
        } else {
            x = 0;
            var candidate = new Position(x, previous.y);
            candidates = (obstacles
                .filter((e) => (e.y == previous.y && e.x < previous.x))
                .sort((a, b) => b.x - a.x));
            if (candidates.length > 0) {
                candidate = candidates[0];
                x = candidate.x + 1;
            }
        }
        y = previous.y;
    } else {
        if (direction.sign == Sign.positive) {
            y = gridNum - 1;
            var candidate = new Position(previous.x, y);
            candidates = (obstacles
                .filter((e) => (e.x == previous.x && e.y > previous.y))
                .sort((a, b) => a.y - b.y));
            if (candidates.length > 0) {
                candidate = candidates[0];
                y = candidate.y - 1;
            }
        } else {
            y = 0;
            var candidate = new Position(previous.x, 0);
            candidates = (obstacles
                .filter((e) => (e.x == previous.x && e.y < previous.y))
                .sort((a, b) => b.y - a.y));
            if (candidates.length > 0) {
                candidate = candidates[0];
                y = candidate.y + 1;
            }
        }
        x = previous.x;
    }
    return new Position(x, y);
}

function fisherYatesShuffle(arr) {
    for (var i = arr.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        [arr[i], arr[j]] = [arr[j], arr[i]];
    }
}

function generateObstacles(position, maxObstaclesNum) {
    obstaclesNumber = Math.floor(Math.random() * maxObstaclesNum);

    var arr = [];
    for (var i = 0; i < gridNum * gridNum; i++) {
        arr.push(i);
    }

    fisherYatesShuffle(arr);
    return arr.slice(0, obstaclesNumber).map((i) => new Position(i % gridNum, Math.floor(i / gridNum))).filter(n => !n.equals(position));
}

function solvePuzzle(start, obstacles) {
    var queue = [];
    var _seenPositions = [];
    var node = new Point(start);
    queue.push(node);
    while (queue.length > 0) {
        node = queue.shift();
        _seenPositions.push(node.position);
        var nextDirections =
            _decideDirectionsFromPrevious(node.previousDirection);
        for (var nextDirection of nextDirections) {
            var nextPosition =
                movePosition(node.position, nextDirection, obstacles);

            if (!_seenPositions.some(e => e.equals(nextPosition))) {
                queue.push(new Point(nextPosition, nextDirection, node));
            }
        }
    }
    var depth = 0;
    var _node = node;
    while (_node.hasParent) {
        depth++;
        _node = _node.parent;
    }
    return {
        'goal_position': node.position,
        'depth': depth,
    };
}

function _decideDirectionsFromPrevious(direction) {
    if (direction == null) {
        return [
            new Direction(Sign.positive, Axis.x),
            new Direction(Sign.positive, Axis.y),
            new Direction(Sign.negative, Axis.x),
            new Direction(Sign.negative, Axis.y),
        ];
    }
    switch (direction.axis) {
        case Axis.x:
            return [Sign.positive, Sign.negative].map((sign) => new Direction(sign, Axis.y));
        case Axis.y:
            return [Sign.positive, Sign.negative].map((sign) => new Direction(sign, Axis.x));
    }
}

function generatePuzzle(args) {
    var obstacles;
    var result;

    var start = new Position(args['start_x'], args['start_y']);
    var minDepth = args['min_depth'];

    while (true) {
        obstacles = generateObstacles(start, Math.floor(3 * minDepth / 4));
        result = solvePuzzle(start, obstacles);
        depth = result['depth'];
        if (depth > minDepth) {
            break;
        }
    }
    return JSON.stringify({
        'obstacles': obstacles,
        'goal_position': result['goal_position'],
    });
}