"""Draw aggregate CleanLine timings as an SVG from p2000 timing.csv."""

import argparse
import csv
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("timing_csv", type=Path)
    parser.add_argument("output_svg", type=Path)
    args = parser.parse_args()
    with args.timing_csv.open(newline="", encoding="utf-8-sig") as handle:
        rows = list(csv.DictReader(handle))
    minutes = [int(row["minutes"]) for row in rows]
    series = [
        ("Original serial", "originalSerialSeconds", "#6b7280"),
        ("Optimized serial", "optimizedSerialSeconds", "#2563eb"),
        ("Optimized parallel (8 workers)", "optimizedParallelSeconds", "#059669"),
    ]
    width, height = 800, 460
    left, right, top, bottom = 82, 25, 35, 80
    x_min, x_max = min(minutes), max(minutes)
    y_max = max(float(row[column]) for row in rows for _, column, _ in series)
    y_max = (int(y_max / 50) + 1) * 50

    def x(value: float) -> float:
        return left + (value - x_min) / (x_max - x_min) * (width - left - right)

    def y(value: float) -> float:
        return height - bottom - value / y_max * (height - top - bottom)

    svg = [
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {width} {height}" role="img" aria-label="CleanLine execution time by recording duration">',
        '<rect width="100%" height="100%" fill="white"/>',
        '<style>text{font-family:Arial,sans-serif;fill:#1f2937;font-size:13px}.title{font-size:18px;font-weight:bold}</style>',
        '<text class="title" x="82" y="25">CleanLine V2 on 33-channel EEG</text>',
    ]
    for tick in range(0, y_max + 1, 50):
        yy = y(tick)
        svg += [
            f'<line x1="{left}" y1="{yy:.1f}" x2="{width-right}" y2="{yy:.1f}" stroke="#e5e7eb"/>',
            f'<text x="{left-12}" y="{yy+4:.1f}" text-anchor="end">{tick}</text>',
        ]
    for minute in minutes:
        xx = x(minute)
        svg.append(f'<text x="{xx:.1f}" y="{height-bottom+25}" text-anchor="middle">{minute}</text>')
    svg += [
        f'<line x1="{left}" y1="{top}" x2="{left}" y2="{height-bottom}" stroke="#374151"/>',
        f'<line x1="{left}" y1="{height-bottom}" x2="{width-right}" y2="{height-bottom}" stroke="#374151"/>',
        f'<text x="{width/2}" y="{height-12}" text-anchor="middle">Recording duration (min)</text>',
        f'<text transform="translate(20 {height/2}) rotate(-90)" text-anchor="middle">Execution time (s)</text>',
    ]
    for index, (label, column, color) in enumerate(series):
        points = [(x(int(row["minutes"])), y(float(row[column]))) for row in rows]
        coord = " ".join(f"{xx:.1f},{yy:.1f}" for xx, yy in points)
        svg.append(f'<polyline points="{coord}" fill="none" stroke="{color}" stroke-width="2.7"/>')
        svg.extend(f'<circle cx="{xx:.1f}" cy="{yy:.1f}" r="4" fill="{color}"/>' for xx, yy in points)
        lx = left + index * 215
        svg += [
            f'<line x1="{lx}" y1="{height-44}" x2="{lx+20}" y2="{height-44}" stroke="{color}" stroke-width="3"/>',
            f'<text x="{lx+26}" y="{height-40}">{label}</text>',
        ]
    svg.append('</svg>')
    args.output_svg.parent.mkdir(parents=True, exist_ok=True)
    args.output_svg.write_text("\n".join(svg) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
